# frozen_string_literal: true

require 'json-schema'

# Register schemata files
Dir.glob("#{Dir.pwd}/schema/schemata/*") do |file|
  schema_hash = YAML.load_file(file)
  schema = JSON::Schema.new(schema_hash, Addressable::URI.parse(file))

  JSON::Validator.add_schema(schema)
end

RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_path = "#{Dir.pwd}/schema/schemata/#{schema}.yml"
    schema_hash = YAML.load_file(schema_path)

    if JSON.parse(response.body).is_a?(Array)
      JSON::Validator.validate!(schema_hash, response.body, strict: true, list: true)
    else
      JSON::Validator.validate!(schema_hash, response.body, strict: true)
    end
  end
end
