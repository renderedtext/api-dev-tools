require "spec_helper"

RSpec.describe RamlVisualizer::Generator do
  describe "#generate" do
    it "should raise Not Implemented" do
      expect { subject.generate(nil, nil) }.to raise_error("Not Implemented")
    end
  end
end
