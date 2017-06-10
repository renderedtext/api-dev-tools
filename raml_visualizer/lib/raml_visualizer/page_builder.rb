require "fileutils"
require "erb"

module RamlVisualizer
  class PageBuilder
    def self.build(template_path, destination_dir, generator)
      FileUtils.mkdir_p(destination_dir)

      PageBuilder.new(template_path, destination_dir, generator)
    end

    def initialize(template_path, destination_dir, generator)
      @template_path = template_path
      @destination_dir = destination_dir
      @generator = generator
    end

    def generate_page(name, args)
      path = "#{@destination_dir}/#{name}"
      content = Page.new(template, args).content

      @generator.generate(path, content)
    end

    private

    def template
      @template ||= File.open(@template_path, "rb") do |file|
        ERB.new(file.read)
      end
    end
  end
end
