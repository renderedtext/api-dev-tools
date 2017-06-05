module RamlVisualizer
  module Model
    class Response < Element
      def properties
        raw_properties = @raw["body"].to_a.first.to_h["properties"].to_a

        @properties ||= raw_properties.map do |raw_property|
          Element.new(raw_property, self)
        end
      end
    end
  end
end
