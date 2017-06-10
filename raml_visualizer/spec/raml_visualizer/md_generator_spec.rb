require "spec_helper"

RSpec.describe RamlVisualizer::MdGenerator do
  let(:destination_path) { "dir/users" }
  let(:content) { "abc" }

  describe "#generate" do
    it "saves to file" do
      expect(File).to receive(:write).with("#{destination_path}.md", content)

      subject.generate(destination_path, content)
    end
  end

  describe ".request_table" do
    context "empty request" do
      it "renders nothing" do
        specs = RamlParser.load("spec/fixtures/json_output.json")

        route = specs.find_route(:get, "/orgs/{username}")

        expect(RamlVisualizer::MdGenerator.request_table(route)).to eq("")
      end
    end

    context "non empty request" do
      it "renders a markdown table" do
        specs = RamlParser.load("spec/fixtures/json_output.json")

        route = specs.find_route(:patch, "/teams/{id}")

        table = RamlVisualizer::MdGenerator.request_table(route)

        expect(table).to eq('''
| Name | Type | Required | Example |
| ---- | ---- | -------- | ------- |
| name | string | false | developers |
| permission | string | false | write |
| description | string | false | Developers team |
''')
      end
    end
  end

  describe ".response_example" do

    context "response is not empty" do
      it "renders only the example" do
        specs = RamlParser.load("spec/fixtures/json_output.json")

        route = specs.find_route(:get, "/orgs/{username}")

        response_example = RamlVisualizer::MdGenerator.response_example(route)

        expect(response_example).to eq('''
```
HTTP status: 200

{
  "id": "86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
  "name": "Rendered Text",
  "url": "https://api.semaphoreci.com/v2/teams/86e78b7e-2f9c-45a7-9939-ec2c9f6f64b5",
  "username": "renderedtext",
  "created_at": "2017-06-10 16:59:51 +0200",
  "updated_at": "2017-06-10 16:59:51 +0200"
}
```
''')
      end
    end

    context "response is empty" do
      it "renders only the header" do
        specs = RamlParser.load("spec/fixtures/json_output.json")

        route = specs.find_route(:delete, "/teams/{id}")

        response_example = RamlVisualizer::MdGenerator.response_example(route)

        expect(response_example).to eq('''
```
HTTP status: 204
```
''')
      end
    end
  end
end
