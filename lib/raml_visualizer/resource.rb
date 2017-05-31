module RamlVisualizer
  class Resource
    attr_reader :parent, :raw_attributes

    def initialize(raw_resource, parent = nil)
      @parent = parent

      @raw_attributes = raw_resource
    end

    def children
      raw_children = @raw_attributes["resources"] || []

      @children ||= raw_children.map do |resource|
        Resource.new(resource, self)
      end
    end

    def with_descendants
      [self] + descendants
    end

    def descendants
      children + children.map(&:descendants).flatten
    end
  end
end
