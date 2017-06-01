require "spec_helper"
require "fileutils"

RSpec.describe RamlVisualizer::EntityPageFactory do
  let(:template_path) { "spec/fixtures" }
  let(:destination_path) { "spec/fixtures" }

  subject { described_class.new(template_path, destination_path) }

  describe "#create_entity_page" do
    let(:entity) { "users" }
    let(:resources) { [double(RamlVisualizer::Resource)] }

    it "creates the entity page" do
      entity_template_path = "#{template_path}/entity_template.html.erb"

      expect(RamlVisualizer::EntityPage).to receive(:generate).with(entity,
                                                                    resources,
                                                                    entity_template_path,
                                                                    destination_path)

      subject.create_entity_page(entity, resources)
    end
  end
end
