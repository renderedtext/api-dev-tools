module RamlVisualizer
  module Model
    class Specification
      def initialize(source)
        @source = source
      end

      def resources
        @resources ||= raw_specification["resources"].map do |raw_resource|
          Model::Resource.new(raw_resource).with_descendants
        end.flatten
      end

      def entities
        @entities ||= resources.group_by { |resource| resource.entity }
      end

      private

      def raw_specification
        @raw_specification ||= SpecificationJson.content(@source)
      end
    end
  end
end
