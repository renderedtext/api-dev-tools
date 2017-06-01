require "erb"
require "ostruct"

module RamlVisualizer
  class EntityPage
    def self.generate(entity, resources, template_path, destination_dir)
      EntityPage.new(entity, resources, template_path).generate(destination_dir)
    end

    def initialize(entity, resources, template_path)
      @entity = entity
      @resources = resources
      @template_path = template_path
    end

    def generate(dir)
      path = "#{dir}/#{@entity}.html"

      File.open(path, "w") { |file| file.write(content) }
    end

    private

    def context
      @context ||= OpenStruct.new(:entity => @entity, :resources => @resources)
    end

    def content
      @content ||= template.result(context.instance_eval do
        each_pair { |key, value| instance_variable_set("@#{key}".to_sym, value) }

        binding
      end)
    end

    def template
      @template ||= File.open(@template_path, "rb") do |file|
        ERB.new(file.read)
      end
    end
  end
end
