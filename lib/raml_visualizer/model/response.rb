module RamlVisualizer
  module Model
    class Response < Element
      def body
        (@raw["body"] && @raw["body"].first).to_h
      end

      def properties
        raw_properties = body["properties"].to_a

        @properties ||= raw_properties.map do |raw_property|
          Element.new(raw_property, self)
        end
      end
    end
  end
end
