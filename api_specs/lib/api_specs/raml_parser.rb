class ApiSpecs
  class RamlParser
    attr_reader :specs

    def initialize(specs)
      @specs = specs
    end

    def routes
      @reoute ||= find_resources(specs["resources"]).map do |raml_resource|
        (raml_resource["methods"] || []).map do |method|
          ApiSpecs::Route.new(raml_resource, method)
        end
      end.flatten
    end

    private

    def find_resources(node)
      if node.is_a?(Array)
        node.map { |r| find_resources(r) }.flatten
      elsif node.is_a?(Hash)
        [node] + find_resources(node["resources"])
      else
        []
      end
    end
  end
end
