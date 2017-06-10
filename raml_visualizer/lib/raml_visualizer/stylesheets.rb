require "fileutils"

module RamlVisualizer
  class Stylesheets
    def initialize(source_dir, destination_dir)
      @source_dir = source_dir
      @destination_dir = destination_dir
    end

    def links
      @links ||= css_files.map do |path|
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"/stylesheets#{path}\">"
      end
    end

    def css_files
      Dir["#{@source_dir}/**/*.css"].map { |path| path.gsub(@source_dir, "") }
    end

    def copy
      FileUtils.mkdir_p(@destination_dir)

      FileUtils.cp_r(@source_dir, "#{@destination_dir}/stylesheets")

      self
    end

  end
end
