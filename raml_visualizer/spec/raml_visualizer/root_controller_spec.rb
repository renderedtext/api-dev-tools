require "spec_helper"

RSpec.describe RamlVisualizer::RootController do
  let(:source_path) { "source" }
  let(:destination_path) { "destination" }
  let(:template_path) { "templates" }
  let(:options) { { :format => "html" } }

  subject { described_class.new(source_path, destination_path, template_path, options) }

  let(:site_builder) { double(RamlVisualizer::SiteBuilder) }
  let(:page_builder) { double(RamlVisualizer::PageBuilder) }

  let(:resource) { double(RamlParser::Resource,
                          :name => "orgs",
                          :index => [],
                          :show => [],
                          :create => [],
                          :update => [],
                          :delete=> [],
                          :connect=> [],
                          :dissconnect=> []) }

  let(:resources) { [resource] }
  let(:specification) { double(RamlParser, :resources => resources) }

  before do
    allow(RamlParser).to receive(:load).and_return(specification)
    allow(specification).to receive(:resources).and_return(resources)

    allow(RamlVisualizer::SiteBuilder).to receive(:new).and_return(site_builder)
    allow(site_builder).to receive(:build_page_builder).and_return(page_builder)
    allow(page_builder).to receive(:generate_page)
  end

  describe "#generate_index_page" do
    it "creates the site builder" do
      expect(RamlVisualizer::SiteBuilder).to receive(:new).with(template_path, destination_path, options)

      subject.generate_index_page
    end

    it "creates a page builder" do
      expect(site_builder).to receive(:build_page_builder).with("index.md.erb", "")

      subject.generate_index_page
    end

    it "generates the index page" do
      expect(page_builder).to receive(:generate_page).with("index", :specification => specification)

      subject.generate_index_page
    end
  end

  describe "#generate_resource_pages" do
    it "creates the site builder" do
      expect(RamlVisualizer::SiteBuilder).to receive(:new).with(template_path, destination_path, options)

      subject.generate_resource_pages
    end

    it "creates a page builder" do
      expect(site_builder).to receive(:build_page_builder).with("resource.md.erb", "")

      subject.generate_resource_pages
    end

    it "generates the resource pages" do
      expect(page_builder).to receive(:generate_page).with("orgs", :resource => resource, :routes => [])

      subject.generate_resource_pages
    end
  end
end
