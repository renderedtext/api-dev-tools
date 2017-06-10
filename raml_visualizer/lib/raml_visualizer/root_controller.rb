module RamlVisualizer
  class RootController
    def initialize(source, destination, templates, options)
      @source = source
      @destination = destination
      @templates = templates
      @options = options
    end

    def generate_index_page
      builder = site_builder.build_page_builder("index.md.erb", "")

      builder.generate_page("index", :specification => specification)
    end

    def generate_entity_pages
      builder = page_builder("resource.md.erb", "")

      specification.resources.each do |resource|
        filename = resource.name.split("_").map(&:downcase).join("_")

        builder.generate_page(filename, :resource => resource)
      end
    end

    private

    def specification
      @specification ||= RamlParser.load(@source)
    end

    def site_builder
      @site_builder ||= SiteBuilder.new(@templates, @destination, @options)
    end

    def page_builder(template_path, destination_dir)
      site_builder.build_page_builder(template_path, destination_dir)
    end
  end
end
