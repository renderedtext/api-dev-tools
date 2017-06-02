require "spec_helper"
require "fileutils"

RSpec.describe "Full integration" do

  before(:all) do
    input_file = "spec/fixtures/json_output.json"
    @output_dir = ".spec_output"
    templates_dir = "spec/fixtures/generation"

    @controller = RamlVisualizer::RootController.new(input_file, @output_dir, templates_dir)
  end

  it "generates the index page" do
    @controller.generate_index_page

    content = File.open("#{@output_dir}/index.md", "rb") { |file| file.read }

    expect(content).to include("users")
  end

  it "generates the entity pages" do
    @controller.generate_entity_pages

    content = File.open("#{@output_dir}/entities/users.md", "rb") { |file| file.read }

    expect(content).to include("users")
  end

  after(:all) do
    FileUtils.rm_rf(@output_dir)
  end
end
