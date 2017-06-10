require "spec_helper"

RSpec.describe RamlRspec do

  RamlRspec.setup(:specification_path => "spec/specs.json")

  it "has a version number" do
    expect(RamlRspec::VERSION).not_to be nil
  end

  describe "match_raml_response" do
    context "the actual and tested responses are the same" do
      it "returns true" do
        response = [{
          "id" => "86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
          "name" => "Rendered Text",
          "url" => "https://api.semaphoreci.com/v2/teams/86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
          "username" => "renderedtext",
          "created_at" => "2017-06-10 16:59:51 +0200",
          "updated_at" => "2017-06-10 16:59:51 +0200"
        }, {
          "id" => "86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
          "name" => "Rendered Text",
          "url" => "https://api.semaphoreci.com/v2/teams/86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
          "username" => "renderedtext",
          "created_at" => "2017-06-10 16:59:51 +0200",
          "updated_at" => "2017-06-10 16:59:51 +0200"
        }]

        expect(response).to match_raml_response(:get, "/orgs", 200)
      end
    end

    context "the actual and tested responses are not the same" do
      it "returns false" do
        response = [
          {
            "dasda" => "dasdas"
          }
        ]

        expect(response).to_not match_raml_response(:get, "/orgs", 200)
      end
    end
  end
end
