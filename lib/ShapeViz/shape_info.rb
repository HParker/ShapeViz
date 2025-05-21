require 'json'

module ShapeViz
  class ShapeInfo
    def initialize(shape_string)
      @shape_json = JSON.parse(shape_string)
    end

    def field(field)
      @shape_json[field]
    end

    def address
      @shape_json["address"]
    end

    def id
      @shape_json["id"]
    end

    def depth
      @shape_json["depth"]
    end

    def shape_type
      @shape_json["shape_type"]
    end

    def edges
      @shape_json["edges"]
    end

    def memsize
      @shape_json["memsize"]
    end

    def parent_id
      @shape_json["parent_id"]
    end

    def edge_name
      @shape_json["edge_name"]
    end
  end
end
