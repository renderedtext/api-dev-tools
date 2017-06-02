module RamlVisualizer
  class RootController
    def initialize(source, destination, templates, format)
      @source = source
      @destination = destination
      @templates = templates
      @format = format
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
      template_path = "#{@templates}/index_template.md.erb"

      builder = PageBuilder.build(template_path, @destination, @format)

      builder.generate_page("index", { :entities => entities.keys })
    end

    def generate_entity_pages
      template_path = "#{@templates}/entities/entity_template.md.erb"
      destination_dir = "#{@destination}/entities"

      builder = PageBuilder.build(template_path, destination_dir, @format)

      entities.map do |key, resources|
        builder.generate_page(key, { :entity => key, :resources => resources })
      end
    end
  end
end
