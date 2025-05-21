# frozen_string_literal: true

require "test_helper"

class TestShapeViz < Minitest::Test
  # the readme examples function as the primary test suite. These are available as a place to experiment, but is not complete

  def test_that_it_has_a_version_number
    refute_nil ::ShapeViz::VERSION
  end

  class TestClass
    def initialize(include_a, include_c)
      @a = 1 if include_a
      @b = 1
      @c = 1 if include_c
    end
  end

  def test_reports_all_shapes
    t = ShapeViz::Tracker.start

    t.stop

    t.full_report
  end

  def test_highlights_new_shapes
    t = ShapeViz::Tracker.start

    TestClass.new(true)
    TestClass.new(false)

    t.stop

    t.full_report
  end

  def test_short_report
    t = ShapeViz::Tracker.start

    TestClass.new(true, true)
    TestClass.new(true, false)

    t.stop

    t.report(out: "skip-last.dot")
  end
end
