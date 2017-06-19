class RamlParser
  class Route

    attr_reader :resource_name
    attr_reader :path

    def initialize(path, resource_name, raml_resource, raml_method)
      @path = path
      @resource_name = resource_name
      @raml_resource = raml_resource
      @raml_method = raml_method
    end

    def display_name
      @raml_method["displayName"]
    end

    def description
      @raml_method["description"]
    end

    def verb
      @raml_method["method"].upcase
    end

    def verb_and_path
      "#{verb} #{path}"
    end

    def request
      return nil unless @raml_method["body"]

      @request ||= Body.new(@raml_method["body"].first)
    end

    def responses
      @resources ||= @raml_method["responses"].map { |r| Response.new(r) }
    end

    def succesfull_response
      responses.find(&:succesfull?)
    end

    def index?
      verb == "GET" && collection_route?
    end

    def show?
      verb == "GET" && member_route?
    end

    def create?
      verb == "POST" && collection_route?
    end

    def update?
      verb == "PATCH" && member_route?
    end

    def delete?
      verb == "DELETE" && member_route?
    end

    def connect?
      verb == "POST" && connection_route?
    end

    def dissconnect?
      verb == "DELETE" && connection_route?
    end

    private

    def member_route?
      !connection_route? && path_ends_with_a_param?
    end

    def collection_route?
      !connection_route? && !path_ends_with_a_param?
    end

    def connection_route?
      path.split("/").count == 5
    end

    def path_ends_with_a_param?
      path[-1] == "}"
    end

  end
end
