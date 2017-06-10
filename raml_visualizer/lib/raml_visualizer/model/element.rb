module RamlVisualizer
  module Model
    class Element
      attr_reader :raw, :parent

      def initialize(raw_element, parent = nil)
        @raw = raw_element
        @parent = parent
      end
    end
  end
end
