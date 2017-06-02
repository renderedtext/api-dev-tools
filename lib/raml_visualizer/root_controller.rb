module RamlVisualizer
  class RootController
    def initialize(source, destination, templates)
      @source = source
      @destination = destination
      @templates = templates
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

    def generate_index_page
      template_path = "#{@templates}/index_template.html.erb"

      factory = PageFactory.build(template_path, @destination)

      factory.generate_page("index", { :entities => entities.keys })
    end

    def generate_entity_pages
      template_path = "#{@templates}/entities/entity_template.html.erb"
      destination_dir = "#{@destination}/entities"

      factory = PageFactory.build(template_path, destination_dir)

      entities.map do |key, resources|
        factory.generate_page(key, { :entity => key, :resources => resources })
      end
    end
  end
end
