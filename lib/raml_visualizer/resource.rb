module RamlVisualizer
  class Resource
    attr_reader :parent, :display_name

    def initialize(raw_resource, parent = nil)
      @parent = parent

      @display_name = raw_resource["display_name"]
      @raw_children = raw_resource["resources"] || []
    end

    def entity
      tokens = @display_name.split("/")

      tokens.count >= 4 ? tokens[3] : tokens[1]
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
