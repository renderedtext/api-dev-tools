class RamlParser
  class Resource

    attr_reader :name
    attr_reader :display_name
    attr_reader :routes

    def initialize(name, display_name, routes)
      @name = name
      @display_name = display_name
      @routes = routes
    end

    def index
      routes.select(&:index?)
    end

    def show
      routes.select(&:show?)
    end

    def create
      routes.select(&:create?)
    end

    def update
      routes.select(&:update?)
    end

    def delete
      routes.select(&:delete?)
    end

    def connect
      routes.select(&:connect?)
    end

    def dissconnect
      routes.select(&:dissconnect?)
    end

  end
end
