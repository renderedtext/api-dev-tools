require "spec_helper"
require "fileutils"

RSpec.describe RamlVisualizer::Stylesheets do
  before(:all) do
    @input_dir = ".spec_input"
    @output_dir = ".spec_output"

    FileUtils.mkdir_p(@input_dir)
    FileUtils.mkdir_p("#{@input_dir}/subdir")
    FileUtils.touch("#{@input_dir}/a.css")
    FileUtils.touch("#{@input_dir}/b.css")
    FileUtils.touch("#{@input_dir}/subdir/c.css")
  end

  subject { described_class.new(@input_dir, @output_dir) }

  describe "#links" do
    it "returns HTML links" do
      expect(subject.links.sort).to eql([
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheets/a.css\">",
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheets/b.css\">",
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheets/subdir/c.css\">"
      ])
    end
  end

  describe "#copy" do
    before { FileUtils.mkdir_p(@output_dir) }

    it "copies the stylesheets" do
      subject.copy

      expect(Dir["#{@output_dir}/**/*.css"].sort).to eql([
        "#{@output_dir}/stylesheets/a.css",
        "#{@output_dir}/stylesheets/b.css",
        "#{@output_dir}/stylesheets/subdir/c.css"
      ])
    end

    after { FileUtils.rm_rf("#{@output_dir}") }
  end

  after(:all) { FileUtils.rm_rf(@input_dir) }
end
