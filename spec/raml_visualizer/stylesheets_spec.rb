require "spec_helper"
require "fileutils"

RSpec.describe RamlVisualizer::Stylesheets do
  before(:all) do
    @input_dir = ".spec_input"
    @output_dir = ".spec_output"

    FileUtils.mkdir_p(@input_dir)
    FileUtils.touch("#{@input_dir}/a.css")
    FileUtils.touch("#{@input_dir}/b.css")
  end

  subject { described_class.new(@input_dir, @output_dir) }

  describe "#links" do
    it "returns HTML links" do
      expect(subject.links.sort).to eql([
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"/#{@output_dir}/a.css\">",
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"/#{@output_dir}/b.css\">"
      ])
    end
  end

  describe "#copy" do
    before { FileUtils.mkdir_p(@output_dir) }

    it "copies the stylesheets" do
      subject.copy

      expect(Dir["#{@output_dir}/**/*.css"].sort).to eql([
        "#{@output_dir}/a.css",
        "#{@output_dir}/b.css"
      ])
    end

    after { FileUtils.rm_rf("#{@output_dir}") }
  end

  after(:all) { FileUtils.rm_rf(@input_dir) }
end
