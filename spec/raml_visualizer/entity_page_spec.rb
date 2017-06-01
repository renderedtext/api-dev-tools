require "spec_helper"
require "fileutils"

RSpec.describe RamlVisualizer::EntityPage do
  let(:template_path) { "spec/fixtures/entity_template.html.erb" }
  let(:output_dir) { "spec/fixtures" }
  let(:output_path) { "#{output_dir}/users.html" }

  describe ".generate" do
    it "writes the page content" do
      described_class.generate("users", [{ "displayName" => 123 }], template_path, output_dir)

      file_content = File.open(output_path, "rb") { |file| file.read }

      expect(file_content).to eql("Testing: users\n")
    end

    after do
      FileUtils.rm(output_path)
    end
  end
end
