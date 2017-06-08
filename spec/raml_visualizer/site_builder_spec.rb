require "spec_helper"

RSpec.describe RamlVisualizer::SiteBuilder do
  let(:template_root) { "template" }
  let(:destination_root) { "destination" }

  describe "#build_page_builder" do
    context "Markdown format" do
      let(:options) { { :format => "md" } }
      let(:generator) { double(RamlVisualizer::MdGenerator) }

      subject { described_class.new(template_root, destination_root, options) }

      before { allow(RamlVisualizer::MdGenerator).to receive(:new).and_return(generator) }

      it "builds the page builder" do
        expect(RamlVisualizer::PageBuilder).to receive(:build).with("#{template_root}/t1", "#{destination_root}/d1", generator)

        subject.build_page_builder("t1", "d1")
      end

      it "creates the generator" do
        expect(RamlVisualizer::MdGenerator).to receive(:new)

        subject.build_page_builder("t1", "d1")
      end
    end

    context "HTML format" do
      let(:options) { { :format => "html" } }
      let(:generator) { double(RamlVisualizer::HtmlGenerator) }

      subject { described_class.new(template_root, destination_root, options) }

      before { allow(RamlVisualizer::HtmlGenerator).to receive(:new).and_return(generator) }

      it "builds the page builder" do
        expect(RamlVisualizer::PageBuilder).to receive(:build).with("#{template_root}/t1", "#{destination_root}/d1", generator)

        subject.build_page_builder("t1", "d1")
      end

      it "creates the generator" do
        expect(RamlVisualizer::HtmlGenerator).to receive(:new).with(nil)

        subject.build_page_builder("t1", "d1")
      end

      context "there are stylesheets" do
        let(:options) { { :format => "html", :stylesheets_dir => "stylesheets_dir" } }
        let(:stylesheets) { double(RamlVisualizer::Stylesheets) }

        subject { described_class.new(template_root, destination_root, options) }

        before do
          allow(RamlVisualizer::Stylesheets).to receive(:new).and_return(stylesheets)
          allow(stylesheets).to receive(:copy).and_return(stylesheets)
        end

        it "creates the stylesheets object" do
          expect(RamlVisualizer::Stylesheets).to receive(:new).with(options[:stylesheets_dir], destination_root)

          subject.build_page_builder("t1", "d1")
        end

        it "copies the stylesheets" do
          expect(stylesheets).to receive(:copy)

          subject.build_page_builder("t1", "d1")
        end

        it "creates the generator with stylesheets" do
          expect(RamlVisualizer::HtmlGenerator).to receive(:new).with(stylesheets)

          subject.build_page_builder("t1", "d1")
        end
      end
    end
  end
end
