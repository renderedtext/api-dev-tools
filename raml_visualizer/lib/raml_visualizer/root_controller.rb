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

    def generate_resource_pages
      builder = page_builder("resource.md.erb", "")

      specification.resources.each do |resource|
        builder.generate_page(resource.name, :resource => resource, :routes => sorted_routes(resource))
      end
    end

    private

    def sorted_routes(resource)
      [
        resource.index,
        resource.show,
        resource.create,
        resource.update,
        resource.delete,
        resource.connect,
        resource.dissconnect
      ].flatten
    end

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
