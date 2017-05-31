require "json"

module RamlVisualizer
  class SpecificationJson
    def self.content(path)
      RamlVisualizer::SpecificationJson.new(path).content
    end

    def initialize(path)
      @path = path
    end

    def content
      @content ||= File.open(@path, "rb") do |file|
        JSON.parse(file.read)
      end
    end
  end
end
