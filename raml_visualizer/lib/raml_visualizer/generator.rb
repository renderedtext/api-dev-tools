module RamlVisualizer
  class Generator
    def generate(path, content)
      raise "Not Implemented"
    end

    protected

    def save(path, content)
      File.write(path, content)
    end
  end
end
