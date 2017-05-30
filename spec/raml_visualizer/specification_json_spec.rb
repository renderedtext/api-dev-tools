require "spec_helper"

RSpec.describe RamlVisualizer::SpecificationJson do
  let(:fixture_path) { "spec/fixtures/json-output.json" }

  subject { described_class.new(fixture_path) }

  describe "#content" do
    context "file is loaded" do
      before do
        subject.load
      end

      it "returns the content of the file" do
        expect(subject.content.keys.include?("resources")).to be true
      end
    end

    context "file is not loaded" do
      it "returns nil" do
        expect(subject.content).to be nil
      end
    end
  end

  describe "#load" do
    it "loads the file" do
      expect(File).to receive(:open).with(fixture_path, "rb")

      subject.load
    end
  end
end
