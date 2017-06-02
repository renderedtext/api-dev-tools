require "spec_helper"
require "erb"
require "fileutils"

RSpec.describe RamlVisualizer::PageFactory do
  let(:template_path) { "something/templates" }
  let(:destination_path) { "something/output" }

  subject { described_class.new(template_path, destination_path) }

  describe ".build" do
    before do
      allow(FileUtils).to receive(:mkdir_p)
    end

    it "creates the directory" do
      expect(FileUtils).to receive(:mkdir_p).with(destination_path)

      described_class.build(template_path, destination_path)
    end

    it "creates the factory" do
      expect(described_class).to receive(:new).with(template_path, destination_path)

      described_class.build(template_path, destination_path)
    end
  end

  context "page creation" do
    before do
      @page = double(RamlVisualizer::Page)
      allow(RamlVisualizer::Page).to receive(:new).and_return(@page)

      @template = double(ERB)
      allow(File).to receive(:open).and_return(@template)

      @args = { :entity => "users" }
    end

    describe "#create_page" do
      it "creates a page" do
        destination = "#{destination_path}/users.html"

        expect(RamlVisualizer::Page).to receive(:new).with(@template, destination, @args)

        subject.create_page("users", @args)
      end

      it "returns the page" do
        expect(subject.create_page("users", @args)).to eql(@page)
      end
    end

    describe "#generate_page" do
      it "generates the page" do
        expect(@page).to receive(:generate)

        subject.generate_page("users", @args)
      end
    end
  end
end
