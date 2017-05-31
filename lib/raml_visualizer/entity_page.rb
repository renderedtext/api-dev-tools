require "erb"
require "ostruct"

module RamlVisualizer
  class EntityPage
    TEMPLATE_PATH = "templates/entity.html.erb"

    def self.generate(entity, resources, dir)
      EntityPage.new(entity, resources).generate(dir)
    end

    def initialize(entity, resources)
      @entity = entity
      @resources = resources
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
      @template ||= File.open(TEMPLATE_PATH, "rb") do |file|
        ERB.new(file.read)
      end
    end
  end
end
