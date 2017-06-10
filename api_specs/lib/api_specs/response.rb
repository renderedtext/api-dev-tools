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

    def fields

    end
  end
end
