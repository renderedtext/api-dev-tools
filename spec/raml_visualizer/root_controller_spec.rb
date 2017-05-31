require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "source" }
  let(:destination_path) { "destination" }

  subject { described_class.new(source_path, destination_path) }

  before do
    @specification_json = double(RamlVisualizer::SpecificationJson)
    allow(@specification_json).to receive(:content).and_return(
      "resources" => [{ "resources" => [] }]
    )
    allow(RamlVisualizer::SpecificationJson).to receive(:new).and_return(@specification_json)
  end

  describe "#specification" do
    it "loads the specification" do
      expect(RamlVisualizer::SpecificationJson).to receive(:new).with(source_path)

      subject.specification
    end

    it "gets the contents of the specification" do
      expect(@specification_json).to receive(:content)

      subject.specification
    end
  end

  describe "#resources" do
    it "creates resources" do
      expect(subject.resources.first).to be_a(RamlVisualizer::Resource)
    end
  end

  describe "#entities" do
    before do
      @resource_1 = double(RamlVisualizer::Resource, :raw_attributes => { "absoluteUri" => "/base/users" })
      @resource_2 = double(RamlVisualizer::Resource, :raw_attributes => { "absoluteUri" => "/base/tokens" })

      subject.instance_variable_set(:@resources, [@resource_1, @resource_2])
      subject.instance_variable_set(:@specification, { "baseUri" => "/base" })
    end

    it "creates entities" do
      expect(subject.entities).to eql(
        "users" => [@resource_1], "tokens" => [@resource_2]
      )
    end
  end

  describe "#generate_pages" do
    before do
      @resource = double(RamlVisualizer::Resource, :entity => "users")

      subject.instance_variable_set(:@entities, { "users" => [@resource] })

      allow(FileUtils).to receive(:mkdir_p)
      allow(RamlVisualizer::EntityPage).to receive(:generate)
    end

    it "generates the output directory" do
      expect(FileUtils).to receive(:mkdir_p).with(destination_path)

      subject.generate_pages
    end

    it "generates the entity pages" do
      expect(RamlVisualizer::EntityPage).to receive(:generate).with("users", [@resource], destination_path)

      subject.generate_pages
    end
  end
end
