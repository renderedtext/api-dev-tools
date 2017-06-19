class RamlParser
  class Body

    def initialize(raw)
      @raw = raw
    end

    def required?
      @raw["required"]
    end

    def type
      @raw["type"]
    end

    def name
      @raw["key"]
    end

    def properties
      @raw["properties"].map { |field| self.class.new(field) }
    end

    def structure
      case type
      when "array"  then [ self.class.new(@raw["items"]).structure]
      when "object" then properties.map { |e| [e.name, e.type] }.to_h
      end
    end

    def example
      case type
      when "array"    then [ self.class.new(@raw["items"]).example ]
      when "object"   then properties.map { |e| [e.name, e.example] }.to_h
      when "datetime" then "2017-06-10 16:59:51 +0200"
      else
        if @raw["example"]
          @raw["example"]
        elsif @raw["examples"] && @raw["examples"].first
          @raw["examples"].first["structuredValue"]
        end
      end
    end

  end
end
