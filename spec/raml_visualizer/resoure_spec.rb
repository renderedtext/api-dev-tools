require "spec_helper"

RSpec.describe RamlVisualizer::Resource do
  subject { described_class.new({}) }

  describe "#children" do
    context "subject has no children" do
      it "returns an empty array" do
        expect(subject.children).to eql([])
      end
    end

    context "subject has children" do
      subject { described_class.new("resources" => [{}]) }

      it "returns an array of child objects" do
        expect(subject.children.count).to eql(1)
      end

      it "returns children as Resource objects" do
        expect(subject.children.first).to be_a(described_class)
      end

      it "sets self as child's parent" do
        expect(subject.children.first.parent).to eql(subject)
      end
    end
  end

  describe "#with_descendants" do
    context "resource has no descendants" do
      it "returns an empty array" do
        expect(subject.with_descendants).to eql([subject])
      end
    end

    context "resource has descendants" do
      let(:childs_child_resource) { { "resources" => [] } }
      let(:child_resource) { { "resources" => [childs_child_resource] } }
      let(:raw_resource) { { "resources" => [child_resource] } }

      subject { described_class.new(raw_resource) }

      it "returns all descendants" do
        expect(subject.with_descendants.count).to eql(3)
      end

      it "returns descendants of single type" do
        expect(subject.with_descendants.map(&:class).uniq.count).to eql(1)
      end

      it "returns descendants of type Resource" do
        expect(subject.with_descendants.map(&:class).uniq.first).to eql(RamlVisualizer::Resource)
      end
    end
  end

  describe "#descendants" do
    context "resource has no descendants" do
      it "returns an empty array" do
        expect(subject.descendants).to eql([])
      end
    end

    context "resource has descendants" do
      let(:childs_child_resource) { { "resources" => [] } }
      let(:child_resource) { { "resources" => [childs_child_resource] } }
      let(:raw_resource) { { "resources" => [child_resource] } }

      subject { described_class.new(raw_resource) }

      it "returns all descendants" do
        expect(subject.descendants.count).to eql(2)
      end

      it "returns descendants of single type" do
        expect(subject.descendants.map(&:class).uniq.count).to eql(1)
      end

      it "returns descendants of type Resource" do
        expect(subject.descendants.map(&:class).uniq.first).to eql(RamlVisualizer::Resource)
      end
    end
  end
end
