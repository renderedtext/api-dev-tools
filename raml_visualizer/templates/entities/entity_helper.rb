def body_entity_name(body)
  name = body["displayName"]

  name == body["key"] ? "-" : name
end

def resource_path(resource)
  "#{resource.raw["parentUrl"]}#{resource.raw["relativeUri"]}"
end

def method_short_description(method)
  method.raw["description"].to_s.split("\n").first
end

def table_line(fields)
  "| #{fields.join(" | ")} |"
end

def a_table(header, objects)
  return unless objects.to_a.any?

  header_line = table_line([header.keys])
  break_line  = table_line(header.count.times.map { "---" })

  body_lines = objects.map do |object|
    fields = header.values.map { |key| table_field(object, key) }

    table_line(fields)
  end

  lines = [header_line] + [break_line] + body_lines

  lines.join("\n")
end

def table_field(object, key)
  object = object.raw if object.respond_to?(:raw)

  value = object[key]

  if value.nil?
    "-"
  elsif value.kind_of?(Array)
    "[#{value.join(", ")}]"
  else
    value
  end
end

def uri_parameters_table(parameters)
  header = { "Name" => "displayName", "Type" => "type", "Required?" => "required" }

  a_table(header, parameters)
end

def properties_table(properties)
  headers_list = {
    "displayName" => "Name",
    "type" => "Type",
    "required" => "Required?",
    "format" => "Format",
    "enum" => "Enumeration"
  }

  keys = headers_list.keys & properties.map(&:raw).map(&:keys).flatten.uniq

  header = keys.map { |key| [headers_list[key], key] }.to_h

  a_table(header, properties)
end
