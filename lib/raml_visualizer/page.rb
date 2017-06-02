module RamlVisualizer
  class Page
    def initialize(template, destination_path, args)
      @template = template
      @destination_path = destination_path
      @args = args
    end

    def generate
      File.open(@destination_path, "w") { |file| file.write(content) }
    end

    private

    def context
      @context ||= OpenStruct.new(@args)
    end

    def content
      @content ||= @template.result(context.instance_eval do
        each_pair { |key, value| instance_variable_set("@#{key}".to_sym, value) }

        binding
      end)
    end
  end
end
