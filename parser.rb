class DSL
  def method_missing(name, *args, &block)
    abort "No method #{name} for #{self.class.name}"
  end
end

class Parser < DSL
  attr_reader :apis

  def initialize(path)
    @path = path
    @apis = []

    instance_eval File.read(@path)
  end

  def api(name, params = {}, &block)
    @apis << Api.new(name, params, &block)
  end
end

class Api < DSL
  attr_reader :name
  attr_reader :routes
  attr_reader :stability

  def initialize(name, params, &block)
    @name = name
    @stability = params[:stability]
    @routes = []

    instance_eval(&block)
  end

  def get(path, params = {}, &block)
    @routes << Route.new("get", path, params, &block)
  end

  def post(path, params = {}, &block)
    @routes << Route.new("post", path, params, &block)
  end

  def patch(path, params = {}, &block)
    @routes << Route.new("patch", path, params, &block)
  end

  def delete(path, params = {}, &block)
    @routes << Route.new("delete", path, params, &block)
  end

end

class Response < DSL
  attr_reader :code
  attr_reader :schema

  def initialize(params = {})
    @code = params[:code]
    @schema = params[:schema]
  end
end

class Route < DSL
  attr_reader :verb
  attr_reader :path
  attr_reader :schema
  attr_reader :responses

  def initialize(verb, path, params, &block)
    @verb = verb
    @path = path
    @request = params[:schema]
    @responses = []

    instance_eval(&block)
  end

  def get_description
    @description
  end

  def description(text)
    @description = text
  end

  def response(params)
    @responses << Response.new(params)
  end
end

parser = Parser.new("definition")

parser.apis.each do |api|
  puts "# #{api.name} (#{api.stability})"

  api.routes.each do |route|
    puts "## #{route.get_description}"
    puts "   #{route.verb.upcase} #{route.path}, request -> #{route.schema || ":empty"}"

    route.responses.each do |response|
      puts "     #{response.code} -> #{response.schema}"
    end
  end
  puts
end
