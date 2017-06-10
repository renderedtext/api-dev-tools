require "spec_helper"

RSpec.describe RamlVisualizer::HtmlGenerator do
  let(:destination_path) { "dir/users" }
  let(:content) { "abc" }

  before do
    allow(Redcarpet::Render::HTML).to receive(:new)

    @markdown = double(Redcarpet::Markdown)
    allow(Redcarpet::Markdown).to receive(:new).and_return(@markdown)
  end

  describe "#generate" do
    before do
      allow(File).to receive(:write)

      @processed_content = "cba"
      allow(@markdown).to receive(:render).and_return(@processed_content)
    end

    it "saves to file" do
      expect(File).to receive(:write).with(destination_path + ".html", @processed_content)

      subject.generate(destination_path, content)
    end

    context "stylesheets are included" do
      let(:stylesheets) { double(RamlVisualizer::Stylesheets) }
      let(:links) { ["<link a>", "<link b>"] }

      subject { described_class.new(stylesheets) }

      before { allow(stylesheets).to receive(:links).and_return(links) }

      it "adds the links block to content" do
        expected_content = "#{links.join("\n")}\n\n#{@processed_content}"

        expect(File).to receive(:write).with(destination_path + ".html", expected_content)

        subject.generate(destination_path, content)
      end
    end
  end
end
