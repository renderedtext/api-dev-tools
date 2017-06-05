require "spec_helper"

RSpec.describe RamlVisualizer::Model::Response do
  let(:property) { { "type" => "string" } }
  let(:raw_response) { { "body" => [{ "properties" => [property] }] } }

  subject { described_class.new(raw_response) }

  describe "#properties" do
    it "returns Element objects" do
      expect(subject.properties.first).to be_a(RamlVisualizer::Model::Element)
    end

    it "returns the correct objects" do
      expect(subject.properties.first.raw["type"]).to eql(property["type"])
    end
  end
end
