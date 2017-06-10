require "spec_helper"
require "byebug"

RSpec.describe ApiSpecs do

  it "has a version number" do
    expect(ApiSpecs::VERSION).not_to be nil
  end

  specify "api specification" do
    specs = ApiSpecs.load("spec/specs.json")

    expect(specs.resources.map(&:name)).to match_array [
      "Orgs",
      "Config Files",
      "Env Vars",
      "Projects",
      "Shared Configs",
      "Teams"
    ]

    shared_configs = specs.find_resource_by_name("Shared Configs")

    expect(shared_configs.index.map(&:verb_and_path)).to match_array [
      "GET /orgs/{org_username}/shared_configs",
      "GET /teams/{team_id}/shared_configs",
      "GET /projects/{project_id}/shared_configs",
    ]

    expect(shared_configs.show.map(&:verb_and_path)).to match_array [
      "GET /shared_configs/{id}"
    ]

    expect(shared_configs.create.map(&:verb_and_path)).to match_array [
      "POST /orgs/{org_username}/shared_configs"
    ]

    expect(shared_configs.delete.map(&:verb_and_path)).to match_array [
      "DELETE /shared_configs/{id}"
    ]

    expect(shared_configs.update.map(&:verb_and_path)).to match_array [
      "PATCH /shared_configs/{id}"
    ]

    expect(shared_configs.connect.map(&:verb_and_path)).to match_array [
      "POST /teams/{team_id}/shared_configs/{shared_config_id}",
      "POST /projects/{project_id}/shared_configs/{shared_config_id}"
    ]

    expect(shared_configs.dissconnect.map(&:verb_and_path)).to match_array [
      "DELETE /teams/{team_id}/shared_configs/{shared_config_id}",
      "DELETE /projects/{project_id}/shared_configs/{shared_config_id}"
    ]

    get_shared_config = specs.find_route(:get, "/shared_configs/{id}")

    expect(get_shared_config.responses.map(&:code)).to match_array([
      200,
      404
    ])

    expect(get_shared_config.succesfull_response.fields).to match_array([

    ])
  end

end
