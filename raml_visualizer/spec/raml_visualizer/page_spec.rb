require "spec_helper"
require "fileutils"
require "erb"

RSpec.describe RamlVisualizer::Page do
  let(:template_path) { "spec/fixtures/resource.md.erb" }

  before do
    @template = ERB.new(File.read(template_path))
  end

  subject { described_class.new(@template, :resource => "orgs") }

  describe "#content" do
    it "writes the page content" do
      expect(subject.content).to eql("Testing: orgs\n")
    end
  end
end
