module RamlVisualizer
  class RootController
    def initialize(source, destination, templates, options)
      @source = source
      @destination = destination
      @templates = templates
      @options = options
    end

    def specification
      @specification ||= SpecificationJson.content(@source)
    end

    def resources
      @resources ||= specification["resources"].map do |raw_resource|
        Model::Resource.new(raw_resource).with_descendants
      end.flatten
    end

    def entities
      @entities ||= resources.group_by { |resource| resource.entity }
    end

    def generate_index_page
      template_path = "#{@templates}/index_template.md.erb"

      builder = PageBuilder.build(template_path, @destination, @options)

      builder.generate_page("index", :entities => entities.keys)
    end

    def generate_entity_pages
      template_path = "#{@templates}/entities/entity_template.md.erb"
      destination_dir = "#{@destination}/entities"

      builder = PageBuilder.build(template_path, destination_dir, @options)

      entities.map do |key, resources|
        builder.generate_page(key, :entity => key, :resources => resources)
      end
    end
  end
end
