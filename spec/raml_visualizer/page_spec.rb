require "spec_helper"
require "fileutils"
require "erb"

RSpec.describe RamlVisualizer::Page do
  let(:template_path) { "spec/fixtures/entity_template.md.erb" }

  before do
    @template = File.open(template_path, "rb") { |file| ERB.new(file.read) }
  end

  subject { described_class.new(@template, { :entity => "users" }) }

  describe "#content" do
    it "writes the page content" do
      expect(subject.content).to eql("Testing: users\n")
    end
  end
end
