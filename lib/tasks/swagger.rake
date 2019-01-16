# frozen_string_literal: true

namespace :swagger do
  desc 'Convert Swagger schema written by Yaml to JSON'
  task :generate do
    logger = Logger.new(STDOUT)
    yaml_file = 'docs/swagger.yml'
    json_file = 'docs/swagger.json'
    json = JSON.pretty_generate(YAML.load_file(yaml_file))

    File.open(json_file, 'w') do |file|
      file.puts(json)
    end

    logger.info "#{json_file} is successfully generated from #{yaml_file}"
  end
end
