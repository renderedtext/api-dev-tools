require "fileutils"
require "erb"

module RamlVisualizer
  class PageFactory
    def self.build(template_path, destination_dir)
      FileUtils.mkdir_p(destination_dir)

      PageFactory.new(template_path, destination_dir)
    end

    def initialize(template_path, destination_dir)
      @template_path = template_path
      @destination_dir = destination_dir
    end

    def generate_page(destination_type, args)
      create_page(destination_type, args).generate
    end

    def create_page(destination_type, args)
      destination_path = "#{@destination_dir}/#{destination_type}.html"

      Page.new(template, destination_path, args)
    end

    private

    def template
      @template ||= File.open(@template_path, "rb") do |file|
        ERB.new(file.read)
      end
    end
  end
end
