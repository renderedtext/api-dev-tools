require "spec_helper"

RSpec.describe RamlVisualizer::Model::Specification do
  let(:source_path) { "source" }

  subject { described_class.new(source_path) }

  let(:specification_json) { double(RamlVisualizer::SpecificationJson) }

  before do
    allow(specification_json).to receive(:content).and_return(
      "resources" => [{ "resources" => [] }]
    )
    allow(RamlVisualizer::SpecificationJson).to receive(:new).and_return(specification_json)
  end

  describe "#resources" do
    let(:resource) { double(RamlVisualizer::Model::Resource) }

    before do
      allow(RamlVisualizer::Model::Resource).to receive(:new).and_return(resource)
      allow(resource).to receive(:with_descendants).and_return(resource)
    end

    it "loads the specification" do
      expect(RamlVisualizer::SpecificationJson).to receive(:new).with(source_path)

      subject.resources
    end

    it "gets the contents of the specification" do
      expect(specification_json).to receive(:content)

      subject.resources
    end

    it "creates resources" do
      expect(subject.resources).to eql([resource])
    end
  end

  describe "#entities" do
    let(:resource_1) { double(RamlVisualizer::Model::Resource, :entity => "users") }
    let(:resource_2) { double(RamlVisualizer::Model::Resource, :entity => "tokens") }

    before { subject.instance_variable_set(:@resources, [resource_1, resource_2]) }

    it "creates entities" do
      expect(subject.entities).to eql(
        "users" => [resource_1], "tokens" => [resource_2]
      )
    end
  end
end
