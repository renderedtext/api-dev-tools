class ApiSpecs
  class Response
    def initialize(raml_response)
      @raml_response = raml_response
    end

    def code
      @raml_response["code"].to_i
    end

    def succesfull?
      code >= 200 && code < 300
    end

    def empty?
      @raml_response["body"].nil?
    end

    def body
      return nil if empty?

      ApiSpecs::Body.new(@raml_response["body"].first)
    end

    def example
      return nil if empty?

      body.example
    end
  end
end
