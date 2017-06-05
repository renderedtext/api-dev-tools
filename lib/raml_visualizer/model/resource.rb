module RamlVisualizer
  module Model
    class Resource < Element
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
end
