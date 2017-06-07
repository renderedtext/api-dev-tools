require "spec_helper"

RSpec.describe RamlVisualizer::HtmlGenerator do
  let(:destination_dir) { "dir" }
  let(:name) { "users" }
  let(:content) { "abc" }

  subject { described_class.new(destination_dir) }

  before do
    allow(Redcarpet::Render::HTML).to receive(:new)

    @markdown = double(Redcarpet::Markdown)
    allow(Redcarpet::Markdown).to receive(:new).and_return(@markdown)
  end

  describe "#generate" do
    before do
      @file = double(File)
      allow(@file).to receive(:write)
      allow(File).to receive(:open).and_yield(@file)

      @processed_content = "cba"
      allow(@markdown).to receive(:render).and_return(@processed_content)
    end

    it "opens a file for writing" do
      destination_path = "#{destination_dir}/#{name}.html"

      expect(File).to receive(:open).with(destination_path, "w")

      subject.generate(name, content)
    end

    it "saves to file" do
      expect(@file).to receive(:write).with(@processed_content)

      subject.generate(name, content)
    end

    context "stylesheets are included" do
      let(:stylesheets) { double(RamlVisualizer::Stylesheets) }
      let(:links) { ["<link a>", "<link b>"] }

      subject { described_class.new(destination_dir, stylesheets) }

      before { allow(stylesheets).to receive(:links).and_return(links) }

      it "adds the links block to content" do
        expected_content = "#{links.join("\n")}\n\n#{@processed_content}"

        expect(@file).to receive(:write).with(expected_content)

        subject.generate(name, content)
      end
    end
  end
end
