require "json"

module RamlVisualizer
  class SpecificationJson
    attr_accessor :content

    def self.load(path)
      SpecificationJson.new(path).load
    end

    def initialize(path)
      @path = path
    end

    def load
      @content = File.open(@path, "rb") do |file|
        JSON.parse(file.read)
      end

      self
    end
  end
end
