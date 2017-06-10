require "redcarpet"

module RamlVisualizer
  class HtmlGenerator < Generator
    RENDER_OPTIONS = {
      :tables => true,
      :fenced_code_blocks => true
    }

    def initialize(stylesheets = nil)
      @stylesheets = stylesheets

      html_render = Redcarpet::Render::HTML.new
      @markdown = Redcarpet::Markdown.new(html_render, RENDER_OPTIONS)
    end

    def generate(path, raw_content)
      extended_path = "#{path}.html"
      content = links + @markdown.render(raw_content)

      save(extended_path, content)
    end

    private

    def links
      return "" unless @stylesheets

      @stylesheets.links.join("\n") + "\n\n"
    end
  end
end
