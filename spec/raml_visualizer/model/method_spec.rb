require "spec_helper"

RSpec.describe RamlVisualizer::Model::Method do
  let(:response) { { "code" => 200 } }
  let(:raw_resource) { { "responses" => [response] } }

  subject { described_class.new(raw_resource) }

  describe "#responses" do
    it "returns Response objects" do
      expect(subject.responses.first).to be_a(RamlVisualizer::Model::Response)
    end

    it "returns the correct objects" do
      expect(subject.responses.first.raw["code"]).to eql(response["code"])
    end
  end
end
