module RamlVisualizer
  module Model
    class Method < Element
      def responses
        raw_responses = @raw_attributes["responses"].to_a

        @responses ||= raw_responses.map do |raw_response|
          Response.new(raw_response, self)
        end
      end
    end
  end
end
