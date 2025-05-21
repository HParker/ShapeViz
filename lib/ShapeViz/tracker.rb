module ShapeViz
  class Tracker
    def initialize(full)
      # shapeviz must declare all ivars here to not show up in its own tracking
      @full_shapes = nil
      @end_shape_id = nil
      @full_report = full
      @start_shape_id = nil
      @start_shape_id = RubyVM.stat(:next_shape_id) # must happen last
    end

    def self.start
      new(false)
    end

    def self.full_shape_report
      t = new(true)
      t.stop
      t.report
    end

    def stop
      @end_shape_id = RubyVM.stat(:next_shape_id)
    end

    def report(out: "shape-graph.dot")
      if @full_report
        File.write(out, full_shape_graph)
      else
        File.write(out, contextual_shape_graph)
      end
    end

    def self.track(full: false, out: "shape-graph.dot")
      t = new(full)
      yield
      t.stop
      t.report(out: out)
    end

    private

    def full_shape_graph
      seen_ids = Set.new

      out = +"graph \"shape tree\" {\n"
      full_shapes.each do |shape|
        output_shape(seen_ids, shape, out)
        if shape.parent_id == 4294967295
          out << "  node_#{shape.parent_id} [label=\"Root Shape\"] ;\n"
        end
      end

      out << "}\n"
      out
    end

    def contextual_shape_graph
      seen_ids = Set.new
      unresolved_parents = []

      out = +"graph \"shape tree\" {\n"
      full_shapes.each do |shape|
        if !seen_ids.include?(shape.id) && shape.id >= @start_shape_id && shape.id < @end_shape_id
          output_shape(seen_ids, shape, out)

          if shape.parent_id
            unresolved_parents << shape.parent_id
          end
        end
      end

      while unresolved_parents.size.positive?
        parent_id = unresolved_parents.pop

        if parent_id == 4294967295
          out << "  node_#{parent_id} [label=\"Root Shape\"] ;\n"
          next
        end

        shape = full_shapes.find { |sh| sh.id == parent_id }

        if shape && !seen_ids.include?(shape.id) && shape.id < @end_shape_id
          output_shape(seen_ids, shape, out)

          if shape.parent_id
            unresolved_parents << shape.parent_id
          end
        end
      end
      out << "}\n"
      out
    end

    def output_shape(seen_ids, shape, out)
      if shape.id >= @start_shape_id
        color = "color=\"green\""
      else
        color = ""
      end

      out << "  node_#{shape.id} [label=\"#{shape.id} #{shape.shape_type}\" #{color}] ;\n"

      if shape.edge_name
        out << "  node_#{shape.id} -- node_#{shape.parent_id} [label=\"#{shape.edge_name}\"] ;\n"
      else
        out << "  node_#{shape.id} -- node_#{shape.parent_id} ;\n"
      end

      seen_ids.add(shape.id)
    end

    def full_shapes
      @full_shapes ||= ObjectSpace.dump_shapes(output: :string, since: 0).lines.map { |line| ShapeInfo.new(line) }
    end
  end
end
