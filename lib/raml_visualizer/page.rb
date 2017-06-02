module RamlVisualizer
  class Page
    def initialize(template, args)
      @template = template
      @args = args
    end

    def content
      @content ||= @template.result(context.instance_eval do
        each_pair { |key, value| instance_variable_set("@#{key}".to_sym, value) }

        binding
      end)
    end

    private

    def context
      @context ||= OpenStruct.new(@args)
    end
  end
end
