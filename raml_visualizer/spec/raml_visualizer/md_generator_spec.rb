require "spec_helper"

RSpec.describe RamlVisualizer::MdGenerator do
  let(:destination_path) { "dir/users" }
  let(:content) { "abc" }

  describe "#generate" do
    it "saves to file" do
      expect(File).to receive(:write).with("#{destination_path}.md", content)

      subject.generate(destination_path, content)
    end
  end
end
