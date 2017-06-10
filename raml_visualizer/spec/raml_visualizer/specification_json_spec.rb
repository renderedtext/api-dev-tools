require "spec_helper"

RSpec.describe RamlVisualizer::SpecificationJson do
  let(:fixture_path) { "spec/fixtures/json_output.json" }

  describe ".content" do
    it "returns the content of the file" do
      return_value = described_class.content(fixture_path)

      expect(return_value.keys).to include("resources")
    end
  end
end
