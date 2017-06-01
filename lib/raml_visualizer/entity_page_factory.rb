module RamlVisualizer
  class EntityPageFactory
    def initialize(template_dir, destination_path)
      @template_path = "#{template_dir}/entity_template.html.erb"
      @destination_path = destination_path
    end

    def create_entity_page(entity, resources)
      EntityPage.generate(entity, resources, @template_path, @destination_path)
    end
  end
end
