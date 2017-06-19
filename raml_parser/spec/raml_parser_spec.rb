require "spec_helper"
require "byebug"

RSpec.describe RamlParser do

  it "has a version number" do
    expect(RamlParser::VERSION).not_to be nil
  end

  let(:specs) { RamlParser.load("spec/specs.json") }
  let(:shared_configs) { specs.find_resource_by_name("shared_configs") }

  it "can list resource display names" do
    expect(specs.resources.map(&:name)).to match_array [
      "orgs",
      "config_files",
      "env_vars",
      "projects",
      "shared_configs",
      "teams",
      "users"
    ]
  end

  it "can list resource display names" do
    expect(specs.resources.map(&:display_name)).to match_array [
      "Organizations",
      "Configuration Files",
      "Environment Variables",
      "Projects",
      "Shared Configurations",
      "Teams",
      "Users"
    ]
  end

  it "can display route descriptions" do
    expect(shared_configs.routes.map(&:display_name)).to include("Add a shared configuration to a team")
  end

  it "can list index routes" do
    expect(shared_configs.index.map(&:verb_and_path)).to match_array [
      "GET /orgs/{org_username}/shared_configs",
      "GET /teams/{team_id}/shared_configs",
      "GET /projects/{project_id}/shared_configs",
    ]
  end

  it "can list show routes" do
    expect(shared_configs.show.map(&:verb_and_path)).to match_array [ "GET /shared_configs/{id}" ]
  end

  it "can list create routes" do
    expect(shared_configs.create.map(&:verb_and_path)).to match_array [ "POST /orgs/{org_username}/shared_configs" ]
  end

  it "can list delete routes" do
    expect(shared_configs.delete.map(&:verb_and_path)).to match_array [ "DELETE /shared_configs/{id}" ]
  end

  it "can list update routes" do
    expect(shared_configs.update.map(&:verb_and_path)).to match_array [ "PATCH /shared_configs/{id}" ]
  end

  it "can list connect routes" do
    expect(shared_configs.connect.map(&:verb_and_path)).to match_array [
      "POST /teams/{team_id}/shared_configs/{shared_config_id}",
      "POST /projects/{project_id}/shared_configs/{shared_config_id}"
    ]
  end

  it "can list dissconnect routes" do
    expect(shared_configs.dissconnect.map(&:verb_and_path)).to match_array [
      "DELETE /teams/{team_id}/shared_configs/{shared_config_id}",
      "DELETE /projects/{project_id}/shared_configs/{shared_config_id}"
    ]
  end

  it "can create example responses for show" do
    get_shared_config = specs.find_route(:get, "/shared_configs/{id}")

    expect(get_shared_config.responses.map(&:code)).to match_array([ 200, 404 ])

    expect(get_shared_config.succesfull_response.example).to eq(
      "id" => "86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
      "description" => "AWS tokens for deployment",
      "url" => "https://api.semaphoreci.com/v2/shared_configs/86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
      "name" => "AWS Tokens",
      "updated_at" => "2017-06-10 16:59:51 +0200",
      "created_at" => "2017-06-10 16:59:51 +0200"
    )
  end

  it "can create example response for delete" do
    delete_shared_config = specs.find_route(:delete, "/shared_configs/{id}")

    expect(delete_shared_config.responses.map(&:code)).to match_array([ 204, 404 ])
    expect(delete_shared_config.succesfull_response.example).to eq(nil)
  end

  it "can create example response for index" do
    index = specs.find_route(:get, "/projects/{project_id}/config_files")

    expect(index.responses.map(&:code)).to match_array([ 200, 404 ])

    expect(index.succesfull_response.example).to eq([
      {
        "id" => "86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
        "path"=> ".credentials",
        "url" => "https://api.semaphoreci.com/v2/config_files/86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
        "content" => "password: ec2c9f6f64b5",
        "encrypted" => true,
        "shared" => true,
        "updated_at" => "2017-06-10 16:59:51 +0200",
        "created_at" => "2017-06-10 16:59:51 +0200"
      }
    ])
  end

  it "can list request params" do
    patch_shared_config = specs.find_route(:patch, "/shared_configs/{id}")

    expect(patch_shared_config.request.example).to eq({
      "description" => "AWS tokens for deployment",
      "name" => "AWS Tokens"
    })
  end

  it "can display the structure of the response" do
    index_shared_config = specs.find_route(:get, "/projects/{project_id}/shared_configs")

    expect(index_shared_config.succesfull_response.structure).to eq([
      {
        "id" => "string",
        "description" => "string",
        "url" => "string",
        "name" => "string",
        "updated_at" => "datetime",
        "created_at" => "datetime"
      }
    ])
  end

end
