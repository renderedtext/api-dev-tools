module RamlVisualizer
  class MdGenerator < Generator

    def self.request_table(route)
      return "" if route.request.nil?

      header = [
        ["Name", "Type", "Required", "Example"],
        ["----", "----", "--------", "-------"]
      ]

      data = route.request.properties.map do |f|
        [f.name, f.type, f.required?, f.example]
      end

      rows = (header + data).map { |row| "| #{row.join(" | ")} |" }

      "\n" + rows.join("\n") + "\n"
    end

    def self.response_example(route)
      header = "HTTP status: #{route.succesfull_response.code}"

      if route.succesfull_response.example
        example = JSON.pretty_generate(route.succesfull_response.example)

        fenced_code(header + "\n\n" + example)
      else
        fenced_code(header)
      end
    end

    def self.fenced_code(content)
      "\n\`\`\`\n#{content}\n\`\`\`\n"
    end

    def generate(path, content)
      extended_path = "#{path}.md"

      save(extended_path, content)
    end
  end
end
