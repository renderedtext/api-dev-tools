module RamlVisualizer
  class Generator
    def generate(name, content)
      raise "Not Implemented"
    end

    protected

    def save(path, content)
      File.open(path, "w") { |file| file.write(content) }
    end
  end
end
