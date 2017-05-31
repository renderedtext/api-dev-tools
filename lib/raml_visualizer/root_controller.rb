module RamlVisualizer
  class RootController
    attr_accessor :resources, :entities

    def initialize(source_path, destination_path)
      @source_path = source_path
      @destination_path = destination_path
    end

    def load_resources
      json = SpecificationJson.load(@source_path)

      nested_resources = json.content["resources"].map do |raw_resource|
        RamlVisualizer::Resource.new(raw_resource).with_descendants
      end

      @resources = nested_resources.flatten
    end

    def create_entities
      @entities = @resources.group_by(&:entity)
    end

    def save_visualization

    end
  end
end
