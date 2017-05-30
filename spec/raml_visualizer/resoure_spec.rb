require "spec_helper"

RSpec.describe RamlVisualizer::Resource do
  let(:display_name) { "/users" }
  let(:raw_resource) { { :display_name => display_name } }

  subject { described_class.new(raw_resouce) }

  describe "#entity" do
    context "root entity" do
      subject { described_class.new({ "display_name" => "/users" }) }

      it "returns the root entity" do
        expect(subject.entity).to eql("users")
      end
    end

    context "related entity" do
      subject { described_class.new({ "display_name" => "/users/{user_id}/projects" }) }

      it "returns the related entity" do
        expect(subject.entity).to eql("projects")
      end
    end
  end

  describe "#children" do
    context "subject has no children" do
      subject { described_class.new({ "display_name" => "/users" }) }

      it "returns an empty array" do
        expect(subject.children).to eql([])
      end
    end

    context "subject has children" do
      let(:child) { { "display_name" => "/users/{user_id}/projects" } }

      subject do
        described_class.new({
          "display_name" => "/users",
          "resources" => [child]
        })
      end

      it "returns an array of child objects" do
        expect(subject.children.count).to eql(1)
      end

      it "returns children as Resource objects" do
        expect(subject.children.first.class).to eql(described_class)
      end

      it "initializes children correctly" do
        expect(subject.children.first.display_name).to eql(child["display_name"])
      end

      it "sets self as child's parent" do
        expect(subject.children.first.parent).to eql(subject)
      end
    end
  end
end
