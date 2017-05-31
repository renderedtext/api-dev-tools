require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "" }
  let(:destination_path) { "" }
  let(:resource_display_name) { "/users" }

  subject { described_class.new(source_path, destination_path) }

  before do
    specification_json = double(RamlVisualizer::SpecificationJson)
    allow(specification_json).to receive(:content).and_return(
      "resources" => [{ "display_name" => resource_display_name, "resources" => [] }]
    )
    allow(RamlVisualizer::SpecificationJson).to receive(:load).and_return(specification_json)
  end

  describe "#load_resources" do
    it "loads the JSON" do
      expect(RamlVisualizer::SpecificationJson).to receive(:load).with(source_path)

      subject.load_resources
    end

    it "loads resources" do
      subject.load_resources

      expect(subject.resources.first.display_name).to eql(resource_display_name)
    end
  end

  describe "#create_entities" do
    before do
      @resource_1 = double(RamlVisualizer::Resource, :entity => "users")
      @resource_2 = double(RamlVisualizer::Resource, :entity => "tokens")

      subject.instance_variable_set(:@resources, [@resource_1, @resource_2])
    end

    it "creates entities" do
      subject.create_entities

      expect(subject.entities).to eql(
        "users" => [@resource_1], "tokens" => [@resource_2]
      )
    end
  end
end
