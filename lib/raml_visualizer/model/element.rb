module RamlVisualizer
  module Model
    class Element
      attr_reader :raw_attributes, :parent

      def initialize(raw_element, parent = nil)
        @raw_attributes = raw_element
        @parent = parent
      end
    end
  end
end
