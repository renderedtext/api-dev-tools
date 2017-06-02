require "redcarpet"

module RamlVisualizer
  class HtmlGenerator < Generator
    def initialize(destination_dir)
      @destination_dir = destination_dir

      html_render = Redcarpet::Render::HTML.new
      @markdown = Redcarpet::Markdown.new(html_render)
    end

    def generate(name, raw_content)
      path = "#{@destination_dir}/#{name}.html"
      content = @markdown.render(raw_content)

      save(path, content)
    end
  end
end
