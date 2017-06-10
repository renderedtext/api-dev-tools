module RamlVisualizer
  module Model
    class Resource < Element
      def methods
        raw_methods = @raw["methods"].to_a

        @methods ||= raw_methods.map do |raw_method|
          Method.new(raw_method, self)
        end
      end

      def children
        raw_children = @raw["resources"].to_a

        @children ||= raw_children.map do |raw_resource|
          Resource.new(raw_resource, self)
        end
      end

      def with_descendants
        [self] + descendants
      end

      def descendants
        children + children.map(&:descendants).flatten
      end

      def entity
        full_path = @raw["parentUrl"].to_s + @raw["relativeUri"].to_s

        tokens = full_path.split("/")

        tokens.count >= 4 ? tokens[3] : tokens[1]
      end
    end
  end
end
