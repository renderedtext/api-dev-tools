require "spec_helper"

RSpec.describe RamlVisualizer::MdGenerator do
  let(:destination_dir) { "dir" }
  let(:name) { "users" }
  let(:content) { "abc" }

  subject { described_class.new(destination_dir) }

  describe "#generate" do
    before do
      @file = double(File)
      allow(@file).to receive(:write)
      allow(File).to receive(:open).and_yield(@file)
    end

    it "opens a file for writing" do
      destination_path = "#{destination_dir}/#{name}.md"

      expect(File).to receive(:open).with(destination_path, "w")

      subject.generate(name, content)
    end

    it "saves to file" do
      expect(@file).to receive(:write).with(content)

      subject.generate(name, content)
    end
  end
end
