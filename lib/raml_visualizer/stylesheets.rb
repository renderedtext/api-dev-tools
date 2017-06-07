require "fileutils"

module RamlVisualizer
  class Stylesheets
    def initialize(source_dir, destination_dir)
      @source_dir = source_dir
      @destination_dir = destination_dir
    end

    def links
      @links ||= destination_paths.map do |path|
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"/#{path}\">"
      end
    end

    def copy
      FileUtils.mkdir_p(@destination_dir)

      source_paths.each { |path| FileUtils.cp(path, @destination_dir) }

      self
    end

    private

    def source_paths
      @source_paths ||= Dir["#{@source_dir}/**/*.css"]
    end

    def destination_paths
      @destination_paths ||= source_paths.map do |path|
        "#{@destination_dir}/#{path.split("/").last}"
      end
    end
  end
end
