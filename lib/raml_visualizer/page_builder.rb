require "fileutils"
require "erb"

module RamlVisualizer
  class PageBuilder
    def self.build(template_path, destination_dir, options = {})
      FileUtils.mkdir_p(destination_dir)

      PageBuilder.new(template_path, destination_dir, options)
    end

    def initialize(template_path, destination_dir, options = {})
      @template_path = template_path
      @destination_dir = destination_dir
      @options = options
    end

    def generate_page(name, args)
      page = Page.new(template, args)

      generator.generate(name, page.content)
    end

    private

    def generator
      @generator ||=
        case @options[:format]
        when "html" then HtmlGenerator.new(@destination_dir, stylesheets)
        when "md"   then MdGenerator.new(@destination_dir)
        else raise "Format Not Supported"
        end
    end

    def template
      @template ||= File.open(@template_path, "rb") do |file|
        ERB.new(file.read)
      end
    end

    def stylesheets
      return unless (source_dir = @options[:stylesheets_dir])
      return @stylesheets if @stylesheets

      destination_dir = "#{@destination_dir}/stylesheets"

      @stylesheets ||= Stylesheets.new(source_dir, destination_dir).copy
    end
  end
end
