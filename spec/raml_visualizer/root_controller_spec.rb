require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "source" }
  let(:destination_path) { "destination" }
  let(:template_path) { "templates" }
  let(:options) { { :format => "html" } }

  subject { described_class.new(source_path, destination_path, template_path, options) }

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

  context "page building" do
    let(:site_builder) { double(RamlVisualizer::SiteBuilder) }
    let(:page_builder) { double(RamlVisualizer::PageBuilder) }

    before do
      allow(RamlVisualizer::SiteBuilder).to receive(:new).and_return(site_builder)
      allow(site_builder).to receive(:build_page_builder).and_return(page_builder)
      allow(page_builder).to receive(:generate_page)
    end

    describe "#site_builder" do
      it "builds the site builder" do
        expect(RamlVisualizer::SiteBuilder).to receive(:new).with(template_path, destination_path, options)

        subject.site_builder
      end
    end

    describe "#page_buidler" do
      it "builds a page builder" do
        expect(site_builder).to receive(:build_page_builder).with(template_path, destination_path)

        subject.page_builder(template_path, destination_path)
      end
    end

    context "page generation" do
      let(:resource) { double(RamlVisualizer::Model::Resource, :entity => "users") }

      before { subject.instance_variable_set(:@entities, { "users" => [resource] }) }

      describe "#generate_index_page" do
        it "generates the index page" do
          expect(page_builder).to receive(:generate_page).with("index", :entities => ["users"])

          subject.generate_index_page
        end
      end

      describe "#generate_entity_pages" do
        it "generates the index page" do
          expect(page_builder).to receive(:generate_page).with("users", :entity => "users", :resources => [resource])

          subject.generate_entity_pages
        end
      end
    end
  end
end
