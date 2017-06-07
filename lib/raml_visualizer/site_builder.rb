module RamlVisualizer
  class SiteBuilder
    def initialize(template_root, destination_root, options)
      @template_root = template_root
      @destination_root = destination_root
      @options = options
    end

    def build_page_builder(template_relative, destination_relative)
      template_path = "#{@template_root}/#{template_relative}"
      destination_path = "#{@destination_root}/#{destination_relative}"

      PageBuilder.build(template_path, destination_path, generator)
    end

    private

    def generator
      @generator ||=
        case @options[:format]
        when "html" then HtmlGenerator.new(stylesheets)
        when "md"   then MdGenerator.new
        else raise "Format Not Supported"
        end
    end

    def stylesheets
      return unless (source_dir = @options[:stylesheets_dir])

      return @stylesheets if @stylesheets

      destination_dir = "#{@destination_root}/stylesheets"

      @stylesheets = Stylesheets.new(source_dir, destination_dir).copy
    end
  end
end
