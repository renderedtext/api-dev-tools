require "spec_helper"

RSpec.describe RamlVisualizer::MdGenerator do
  let(:destination_path) { "dir/users" }
  let(:content) { "abc" }

  describe "#generate" do
    before do
      @file = double(File)
      allow(@file).to receive(:write)
      allow(File).to receive(:open).and_yield(@file)
    end

    it "opens a file for writing" do
      expect(File).to receive(:open).with(destination_path + ".md", "w")

      subject.generate(destination_path, content)
    end

    it "saves to file" do
      expect(@file).to receive(:write).with(content)

      subject.generate(destination_path, content)
    end
  end
end
