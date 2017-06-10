require "spec_helper"

RSpec.describe RamlVisualizer::Model::Method do
  let(:property) { { "type" => "string" } }
  let(:response) { { "code" => 200 } }
  let(:raw_resource) { {
    "responses" => [response],
    "body" => [{ "properties" => [property] }]
  } }

  subject { described_class.new(raw_resource) }

  describe "#responses" do
    it "returns Response objects" do
      expect(subject.responses.first).to be_a(RamlVisualizer::Model::Response)
    end

    it "returns the correct objects" do
      expect(subject.responses.first.raw["code"]).to eql(response["code"])
    end
  end

  describe "#properties" do
    it "returns Element objects" do
      expect(subject.properties.first).to be_a(RamlVisualizer::Model::Element)
    end

    it "returns the correct objects" do
      expect(subject.properties.first.raw["type"]).to eql(property["type"])
    end
  end
end
