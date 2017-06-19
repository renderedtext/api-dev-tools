class RamlParser
  class Parser
    attr_reader :specs

    def initialize(specs)
      @specs = specs
    end

    def top_level_resources
      specs["resources"].map do |resource|
        name = resource["relativeUri"][1..-1]
        display_name = resource["displayName"]

        routes = all_routes.select { |r| r.resource_name == name }

        Resource.new(name, display_name, routes)
      end
    end

    def all_resources
      find_resources(specs["resources"])
    end

    def all_routes
      grouped_resources = all_resources.group_by do |resource|
        path = resource["absoluteUri"].gsub(@specs["baseUri"], "")

        segments = path.split("/")

        segments.size < 4 ? segments[1] : segments[3]
      end

      grouped_resources.map do |resource_name, resources|
        resources.map do |resource|
          (resource["methods"] || []).map do |method|
            path = resource["absoluteUri"].gsub(@specs["baseUri"], "")

            Route.new(path, resource_name, resource, method)
          end
        end.flatten
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
