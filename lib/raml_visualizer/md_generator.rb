module RamlVisualizer
  class MdGenerator < Generator
    def generate(path, content)
      extended_path = "#{path}.md"

      save(extended_path, content)
    end
  end
end
