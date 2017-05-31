require "spec_helper"

RSpec.describe RamlVisualizer::Resource do
  let(:display_name) { "/users" }
  let(:raw_resource) { { :display_name => display_name } }

  subject { described_class.new(raw_resource) }

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

  describe "#with_descendants" do
    context "resource has no descendants" do
      it "returns an empty array" do
        expect(subject.with_descendants).to eql([subject])
      end
    end

    context "resource has descendants" do
      let(:childs_child_resource) { { "display_name" => "/users/{user_id}/tokens/{token_id}/something", "resources" => [] } }
      let(:child_resource) { { "display_name" => "/users/{user_id}/tokens", "resources" => [childs_child_resource] } }
      let(:raw_resource) { { "display_name" => "/users", "resources" => [child_resource] } }

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
      let(:childs_child_resource) { { "display_name" => "/users/{user_id}/tokens/{token_id}/something", "resources" => [] } }
      let(:child_resource) { { "display_name" => "/users/{user_id}/tokens", "resources" => [childs_child_resource] } }
      let(:raw_resource) { { "display_name" => "/users", "resources" => [child_resource] } }

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
