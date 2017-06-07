require "redcarpet"

module RamlVisualizer
  class HtmlGenerator < Generator
    RENDER_OPTIONS = {
      :tables => true,
      :fenced_code_blocks => true
    }

    def initialize(destination_dir, stylesheets = nil)
      @destination_dir = destination_dir
      @stylesheets = stylesheets

      html_render = Redcarpet::Render::HTML.new
      @markdown = Redcarpet::Markdown.new(html_render, RENDER_OPTIONS)
    end

    def generate(name, raw_content)
      path = "#{@destination_dir}/#{name}.html"
      content = links + @markdown.render(raw_content)

      save(path, content)
    end

    private

    def links
      return "" unless @stylesheets

      @stylesheets.links.join("\n") + "\n\n"
    end
  end
end
