require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "source" }
  let(:destination_path) { "destination" }
  let(:template_path) { "templates" }
  let(:options) { { :format => "html" } }

  subject { described_class.new(source_path, destination_path, template_path, options) }

  let(:site_builder) { double(RamlVisualizer::SiteBuilder) }
  let(:page_builder) { double(RamlVisualizer::PageBuilder) }

  let(:resource) { double(RamlVisualizer::Model::Resource, :entity => "users") }
  let(:specification) { double(RamlVisualizer::Model::Specification) }
  let(:entities) { { "users" => [resource] } }

  before do
    allow(RamlVisualizer::Model::Specification).to receive(:new).and_return(specification)
    allow(specification).to receive(:entities).and_return(entities)

    allow(RamlVisualizer::SiteBuilder).to receive(:new).and_return(site_builder)
    allow(site_builder).to receive(:build_page_builder).and_return(page_builder)
    allow(page_builder).to receive(:generate_page)
  end

  describe "#generate_index_page" do
    it "creates the specification" do
      expect(RamlVisualizer::Model::Specification).to receive(:new).with(source_path)

      subject.generate_index_page
    end

    it "creates the site builder" do
      expect(RamlVisualizer::SiteBuilder).to receive(:new).with(template_path, destination_path, options)

      subject.generate_index_page
    end

    it "creates a page builder" do
      expect(site_builder).to receive(:build_page_builder).with("index_template.md.erb", "")

      subject.generate_index_page
    end

    it "generates the index page" do
      expect(page_builder).to receive(:generate_page).with("index", :entities => ["users"])

      subject.generate_index_page
    end
  end

  describe "#generate_entity_pages" do
    it "creates the specification" do
      expect(RamlVisualizer::Model::Specification).to receive(:new).with(source_path)

      subject.generate_entity_pages
    end

    it "creates the site builder" do
      expect(RamlVisualizer::SiteBuilder).to receive(:new).with(template_path, destination_path, options)

      subject.generate_entity_pages
    end

    it "creates a page builder" do
      expect(site_builder).to receive(:build_page_builder).with("entities/entity_template.md.erb", "entities")

      subject.generate_entity_pages
    end

    it "generates the entity pages" do
      expect(page_builder).to receive(:generate_page).with("users", :entity => "users", :resources => [resource])

      subject.generate_entity_pages
    end
  end
end
