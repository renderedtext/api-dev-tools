require "spec_helper"
require "fileutils"
require "erb"

RSpec.describe RamlVisualizer::Page do
  let(:template_path) { "spec/fixtures/entity_template.html.erb" }
  let(:output_dir) { "spec_output" }
  let(:output_path) { "#{output_dir}/users.html" }

  before do
    @template = File.open(template_path, "rb") { |file| ERB.new(file.read) }
  end

  subject { described_class.new(@template, output_path, { :entity => "users" }) }

  describe "#generate" do
    before do
      FileUtils.mkdir_p(output_dir)
    end

    it "writes the page content" do
      subject.generate

      file_content = File.open(output_path, "rb") { |file| file.read }

      expect(file_content).to eql("Testing: users\n")
    end

    after do
      FileUtils.rm_rf(output_dir)
    end
  end
end
