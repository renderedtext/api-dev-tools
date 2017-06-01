require "spec_helper"
require "fileutils"

RSpec.describe "Full integration" do
  let(:input_file) { "spec/fixtures/json_output.json" }
  let(:output_dir) { ".test_output" }
  let(:templates_dir) { "spec/fixtures" }
  let(:controller) { RamlVisualizer::RootController.new(input_file, output_dir, templates_dir) }

  describe "full integration" do
    it "generates the entity pages" do
      controller.generate_pages

      content = File.open("#{output_dir}/users.html", "rb") { |file| file.read }

      expect(content).to include("users")
    end
  end

  after do
    FileUtils.rm_rf(output_dir)
  end
end
