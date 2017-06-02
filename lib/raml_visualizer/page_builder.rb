require "fileutils"
require "erb"

module RamlVisualizer
  class PageBuilder
    def self.build(template_path, destination_dir, format)
      FileUtils.mkdir_p(destination_dir)

      PageBuilder.new(template_path, destination_dir, format)
    end

    def initialize(template_path, destination_dir, format)
      @template_path = template_path
      @destination_dir = destination_dir
      @format = format
    end

    def generate_page(name, args)
      page = Page.new(template, args)

      generator.generate(name, page.content)
    end

    private

    def generator
      @generator ||=
        case @format
        when "html" then HtmlGenerator.new(@destination_dir)
        when "md"   then MdGenerator.new(@destination_dir)
        else raise "Format Not Supported"
        end
    end

    def template
      @template ||= File.open(@template_path, "rb") do |file|
        ERB.new(file.read)
      end
    end
  end
end
