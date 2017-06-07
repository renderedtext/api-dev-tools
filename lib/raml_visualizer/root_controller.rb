module RamlVisualizer
  class RootController
    def initialize(source, destination, templates, options)
      @source = source
      @destination = destination
      @templates = templates
      @options = options
    end

    def generate_index_page
      builder = site_builder.build_page_builder("index_template.md.erb", "")

      builder.generate_page("index", :entities => entities.keys)
    end

    def generate_entity_pages
      builder = page_builder("entities/entity_template.md.erb", "entities")

      entities.map do |key, resources|
        builder.generate_page(key, :entity => key, :resources => resources)
      end
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

    def page_builder(template_path, destination_dir)
      site_builder.build_page_builder(template_path, destination_dir)
    end

    def site_builder
      @site_builder ||= SiteBuilder.new(@templates, @destination, @options)
    end
  end
end
