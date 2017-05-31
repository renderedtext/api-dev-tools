module RamlVisualizer
  class RootController
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def specification
      @specification ||= SpecificationJson.content(@source)
    end

    def resources
      @resources ||= specification["resources"].map do |raw_resource|
        Resource.new(raw_resource, specification["baseUri"]).with_descendants
      end.flatten
    end

    def entities
      base_uri = specification["baseUri"]

      @entities ||= resources.group_by do |resource|
        tokens = resource.raw_attributes["absoluteUri"].gsub(base_uri, "").split("/")

        tokens.count >= 4 ? tokens[3] : tokens[1]
      end
    end

    def generate_pages
      FileUtils.mkdir_p(@destination)

      entities.map do |key, resources|
        EntityPage.generate(key, resources, @destination)
      end
    end
  end
end
