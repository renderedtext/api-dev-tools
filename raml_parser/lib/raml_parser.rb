require "json"

class RamlParser
  require_relative "raml_parser/version"
  require_relative "raml_parser/parser"
  require_relative "raml_parser/route"
  require_relative "raml_parser/resource"
  require_relative "raml_parser/response"
  require_relative "raml_parser/body"

  def self.load(path)
    new(JSON.parse(File.read(path)))
  end

  def initialize(raml_specs)
    @raml_specs = RamlParser::Parser.new(raml_specs)
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
