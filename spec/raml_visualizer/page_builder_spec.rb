require "spec_helper"
require "erb"
require "fileutils"

RSpec.describe RamlVisualizer::PageBuilder do
  let(:template_path) { "something/templates" }
  let(:destination_path) { "something/output" }
  let(:format) { "md" }

  subject { described_class.new(template_path, destination_path, :format => format) }

  describe ".build" do
    before do
      allow(FileUtils).to receive(:mkdir_p)
    end

    it "creates the directory" do
      expect(FileUtils).to receive(:mkdir_p).with(destination_path)

      described_class.build(template_path, destination_path, format)
    end

    it "creates the builder" do
      expect(described_class).to receive(:new).with(template_path, destination_path, format)

      described_class.build(template_path, destination_path, format)
    end
  end

  context "page creation" do
    before do
      @page = double(RamlVisualizer::Page)
      allow(RamlVisualizer::Page).to receive(:new).and_return(@page)

      @template = double(ERB)
      allow(File).to receive(:open).and_return(@template)

      @args = { :entity => "users" }
    end

    describe "#generate_page" do
      before do
        @content = "abc"

        @page = double(RamlVisualizer::Page)
        allow(@page).to receive(:content).and_return(@content)
        allow(RamlVisualizer::Page).to receive(:new).and_return(@page)

        @generator = double(RamlVisualizer::HtmlGenerator)
        allow(@generator).to receive(:generate)
        allow(RamlVisualizer::HtmlGenerator).to receive(:new).and_return(@generator)
      end

      it "generates a page" do
        expect(RamlVisualizer::Page).to receive(:new).with(@template, @args)

        subject.generate_page("users", @args)
      end

      it "returns the content of a page" do
        expect(@page).to receive(:content)

        subject.generate_page("users", @args)
      end

      context "stylesheets are included in options" do
        let(:options) { { :format => "html", :stylesheets_dir => "specs/fixtures" } }

        subject { described_class.new(template_path, destination_path, options) }

        before do
          @stylesheets = double(RamlVisualizer::Stylesheets)
          allow(@stylesheets).to receive(:copy).and_return(@stylesheets)
          allow(RamlVisualizer::Stylesheets).to receive(:new).and_return(@stylesheets)
        end

        it "creates the stylesheets object" do
          expect(RamlVisualizer::Stylesheets).to receive(:new).with(
            options[:stylesheets_dir],
            "#{destination_path}/stylesheets"
          )

          subject.generate_page("users", @args)
        end

        it "copies the stylesheets" do
          expect(@stylesheets).to receive(:copy)

          subject.generate_page("users", @args)
        end

        it "passes the stylesheets to the generator" do
          expect(RamlVisualizer::HtmlGenerator).to receive(:new).with(destination_path, @stylesheets)

          subject.generate_page("users", @args)
        end
      end

      context "html format" do
        subject { described_class.new(template_path, destination_path, :format => "html") }

        it "creates the generator" do
          expect(RamlVisualizer::HtmlGenerator).to receive(:new).with(destination_path, nil)

          subject.generate_page("users", @args)
        end

        it "generates the page" do
          expect(@generator).to receive(:generate)

          subject.generate_page("users", @args)
        end
      end

      context "md format" do
        subject { described_class.new(template_path, destination_path, :format => "md") }

        before do
          @generator = double(RamlVisualizer::MdGenerator)
          allow(@generator).to receive(:generate)
          allow(RamlVisualizer::MdGenerator).to receive(:new).and_return(@generator)
        end

        it "creates the generator" do
          expect(RamlVisualizer::MdGenerator).to receive(:new).with(destination_path)

          subject.generate_page("users", @args)
        end

        it "generates the page" do
          expect(@generator).to receive(:generate)

          subject.generate_page("users", @args)
        end
      end

      context "unknown format" do
        subject { described_class.new(template_path, destination_path) }

        it "raises Format Not Supported" do
          expect { subject.generate_page("users", @args) }.to raise_error("Format Not Supported")
        end
      end
    end
  end
end
