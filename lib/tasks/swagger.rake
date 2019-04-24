# frozen_string_literal: true

namespace :swagger do
  logger = Logger.new(STDOUT)
  base_dir = 'docs'

  desc 'Merge Swagger schemata to a one Yaml file'
  task :merge do
    yaml_file = "#{base_dir}/swagger.yml"
    index = YAML.load_file("#{base_dir}/index.yml")
    security_schemas = YAML.load_file("#{base_dir}/security_schemes.yml")['securitySchemes']
    request_bodies = YAML.load_file("#{base_dir}/request_bodies.yml")['requestBodies']
    schemas = Dir.glob("#{base_dir}/schemas/*.yml")
                 .map { |file| YAML.load_file(file)['schemas'] }
                 .inject(:merge)
    paths = Dir.glob("#{base_dir}/paths/*.yml")
               .map { |file| YAML.load_file(file)['paths'] }
               .inject(:merge)
    targets = [
      index,
      {
        'components' => {
          'securitySchemes' => security_schemas,
          'requestBodies' => request_bodies,
          'schemas' => schemas
        }
      },
      { 'paths' => paths }
    ]

    File.open(yaml_file, 'w') do |file|
      YAML.dump(targets.inject(:merge), file)
    end

    logger.info "Successfully merged to #{yaml_file}"
  end

  desc 'Convert Swagger schema written by Yaml to JSON'
  task :convert do
    yaml_file = "#{base_dir}/swagger.yml"
    json_file = "#{base_dir}/swagger.json"

    File.open(json_file, 'w') do |file|
      file.puts(JSON.pretty_generate(YAML.load_file(yaml_file)))
    end

    logger.info "#{json_file} is successfully generated from #{yaml_file}"
  end

  desc 'Merge Swagger schemata and generate JSON'
  task generate: ['swagger:merge', 'swagger:convert']
end
