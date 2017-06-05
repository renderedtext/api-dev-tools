module RamlVisualizer
  module Model
    class Response < Element
      def properties
        raw_properties = @raw_attributes["body"].to_a.first.to_h["properties"]

        @properties ||= raw_properties.map do |raw_property|
          Element.new(raw_property, self)
        end
      end
    end
  end
end
