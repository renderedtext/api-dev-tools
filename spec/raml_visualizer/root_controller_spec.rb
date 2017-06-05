require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "source" }
  let(:destination_path) { "destination" }
  let(:template_path) { "templates" }
  let(:format) { "html" }

  subject { described_class.new(source_path, destination_path, template_path, format) }

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
      expect(subject.resources.first).to be_a(RamlVisualizer::Model::Resource)
    end
  end

  describe "#entities" do
    before do
      @resource_1 = double(RamlVisualizer::Model::Resource, :entity => "users")
      @resource_2 = double(RamlVisualizer::Model::Resource, :entity => "tokens")

      subject.instance_variable_set(:@resources, [@resource_1, @resource_2])
    end

    it "creates entities" do
      expect(subject.entities).to eql(
        "users" => [@resource_1], "tokens" => [@resource_2]
      )
    end
  end

  context "page generation" do
    before do
      @builder = double(RamlVisualizer::PageBuilder)
      allow(@builder).to receive(:generate_page)
      allow(RamlVisualizer::PageBuilder).to receive(:build).and_return(@builder)

      @resource = double(RamlVisualizer::Model::Resource, :entity => "users")
      subject.instance_variable_set(:@entities, { "users" => [@resource] })
    end

    describe "#generate_index_page" do
      it "builds the page builder" do
        expected_template_path = "#{template_path}/index_template.md.erb"

        expect(RamlVisualizer::PageBuilder).to receive(:build).with(expected_template_path, destination_path, format)

        subject.generate_index_page
      end

      it "generates the index page" do
        expect(@builder).to receive(:generate_page).with("index", { :entities => ["users"] })

        subject.generate_index_page
      end
    end

    describe "#generate_entity_pages" do
      it "builds the page builder" do
        expected_template_path = "#{template_path}/entities/entity_template.md.erb"
        expected_destination_path = "#{destination_path}/entities"

        expect(RamlVisualizer::PageBuilder).to receive(:build).with(expected_template_path, expected_destination_path, format)

        subject.generate_entity_pages
      end

      it "generates the entity pages" do
        expect(@builder).to receive(:generate_page).with("users", { :entity => "users", :resources => [@resource] })

        subject.generate_entity_pages
      end
    end
  end
end
