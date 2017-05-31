require "spec_helper"
require "fileutils"

RSpec.describe RamlVisualizer::EntityPage do
  let(:template_path) { "spec/fixtures/entity_template.html.erb" }
  let(:output_dir) { "spec/fixtures" }
  let(:output_path) { "#{output_dir}/users.html" }

  before do
    stub_const("#{described_class}::TEMPLATE_PATH", template_path)
  end

  describe ".generate" do
    it "writes the page content" do
      described_class.generate("users", [{ "displayName" => 123 }], output_dir)

      file_content = File.open(output_path, "rb") { |file| file.read }

      expect(file_content).to eql("Testing: users\n")
    end

    after do
      FileUtils.rm(output_path)
    end
  end
end
