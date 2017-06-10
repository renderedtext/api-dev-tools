module RamlVisualizer
  module Model
    class Method < Element
      include ContentBearing

      def responses
        raw_responses = @raw["responses"].to_a

        @responses ||= raw_responses.map do |raw_response|
          Response.new(raw_response, self)
        end
      end
    end
  end
end
