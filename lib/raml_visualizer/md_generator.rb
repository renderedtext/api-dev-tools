module RamlVisualizer
  class MdGenerator < Generator
    def initialize(destination_dir)
      @destination_dir = destination_dir
    end

    def generate(name, content)
      path = "#{@destination_dir}/#{name}.md"

      save(path, content)
    end
  end
end
