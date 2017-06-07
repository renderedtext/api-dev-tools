require "spec_helper"
require "erb"
require "fileutils"

RSpec.describe RamlVisualizer::PageBuilder do
  let(:template_path) { "something/templates" }
  let(:destination_path) { "something/output" }
  let(:generator) { double(RamlVisualizer::Generator) }

  subject { described_class.new(template_path, destination_path, generator) }

  before { allow(generator).to receive(:generate) }

  describe ".build" do
    before do
      allow(FileUtils).to receive(:mkdir_p)
    end

    it "creates the directory" do
      expect(FileUtils).to receive(:mkdir_p).with(destination_path)

      described_class.build(template_path, destination_path, generator)
    end

    it "creates the builder" do
      expect(described_class).to receive(:new).with(template_path, destination_path, generator)

      described_class.build(template_path, destination_path, generator)
    end
  end

  describe "#generate_page" do
    before do
      @content = "abc"

      @page = double(RamlVisualizer::Page)
      allow(@page).to receive(:content).and_return(@content)
      allow(RamlVisualizer::Page).to receive(:new).and_return(@page)

      @template = double(ERB)
      allow(File).to receive(:open).and_return(@template)

      @args = { :entity => "users" }
    end

    it "generates a page" do
      expect(RamlVisualizer::Page).to receive(:new).with(@template, @args)

      subject.generate_page("users", @args)
    end

    it "returns the content of a page" do
      expect(@page).to receive(:content)

      subject.generate_page("users", @args)
    end

    it "generates the page" do
      name = "users"
      full_path = "#{destination_path}/#{name}"

      expect(generator).to receive(:generate).with(full_path, @content)

      subject.generate_page(name, @args)
    end
  end
end
