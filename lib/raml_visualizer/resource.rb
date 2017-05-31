module RamlVisualizer
  class Resource
    attr_reader :parent, :absolute_uri

    def initialize(raw_resource, parent = nil)
      @parent = parent

      @absolute_uri = raw_resource["absoluteUri"]
      @raw_children = raw_resource["resources"] || []
    end

    def children
      @children ||= @raw_children.map do |resource|
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
