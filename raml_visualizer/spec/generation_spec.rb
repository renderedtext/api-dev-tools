require "spec_helper"
require "fileutils"

RSpec.describe "Full integration" do

  before(:all) do
    input_file = "spec/fixtures/json_output.json"
    @output_dir = ".spec_output"
    templates_dir = "spec/fixtures/templates"

    @controller = RamlVisualizer::RootController.new(
      input_file,
      @output_dir,
      templates_dir,
      :format => "md"
    )
  end

  it "generates the index page" do
    @controller.generate_index_page

    content = File.read("#{@output_dir}/index.md")

    expect(content).to include("Orgs")
  end

  it "generates the entity pages" do
    @controller.generate_entity_pages

    content = File.read("#{@output_dir}/teams.md")

    expect(content).to include("Teams")
    expect(content).to include("/teams/{team_id}")
  end

  after(:all) do
    FileUtils.rm_rf(@output_dir)
  end
end
