require "raml_rspec/version"
require "raml_parser"
require "rspec"

module RamlRspec
  module_function

  def setup(options = {})
    @__specification_path = options.fetch(:specification_path)

    @__specification = RamlParser.load(@__specification_path)
  end

  def specification
    raise "Raml specification path not set" unless defined? @__specification

    @__specification
  end

  def routes
    specification.resources.map(&:routes).flatten
  end

  def find_response(verb, path, code)
    route = specification.find_route(verb, path)

    raise "No RAML for '#{verb} #{path} #{code}' found" unless route

    response = route.find { |response| response.code == code }

    raise "No RAML for '#{verb} #{path} #{code}' found" unless response

    response
  end

  def match?(json_structure_a, json_structure_b)
    true
  end

end

RSpec::Matchers.define :match_raml_response do |verb, path, code|
  match { |actual| RamlRspec.match?(actual, RamlRspec.find_response(verb, path, code).structure) }

  failure_message do |actual|
    "expected that:\n\n #{actual} \n\n would match raml structure:\n\n #{RamlRspec.find_response(verb, path, code).structure}"
  end
end
