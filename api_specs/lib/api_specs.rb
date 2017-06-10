require "json"

class ApiSpecs
  require_relative "api_specs/version"
  require_relative "api_specs/raml_parser"
  require_relative "api_specs/route"
  require_relative "api_specs/resource"
  require_relative "api_specs/response"
  require_relative "api_specs/body"

  def self.load(path)
    new(JSON.parse(File.read(path)))
  end

  def initialize(raml_specs)
    @raml_specs = ApiSpecs::RamlParser.new(raml_specs)
  end

  def resources
    @resources ||= @raml_specs.routes.group_by(&:name).map do |name, routes|
      Resource.new(name, routes)
    end
  end

  def find_resource_by_name(resource_name)
    resources.find { |r| r.name == resource_name }
  end

  def find_route(verb, path)
    resources.map(&:routes).flatten.find do |route|
      route.verb == verb.to_s.upcase && route.path == path
    end
  end

end
