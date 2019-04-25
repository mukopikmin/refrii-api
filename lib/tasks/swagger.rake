# frozen_string_literal: true

namespace :swagger do
  logger = Logger.new(STDOUT)
  base_dir = 'docs'

  desc 'Merge Swagger schemata to a one Yaml file'
  task :merge do
    yaml_file = "#{base_dir}/swagger.yml"
    index = YAML.load_file("#{base_dir}/index.yml")
    paths = Dir.glob("#{base_dir}/paths/*.yml")
               .map { |file| YAML.load_file(file) }
               .inject(&:deep_merge)
    components = Dir.glob("#{base_dir}/components/**/*.yml")
                    .map { |file| YAML.load_file(file) }
                    .inject(&:deep_merge)
    targets = [
      index,
      paths,
      components
    ]

    File.open(yaml_file, 'w') do |file|
      YAML.dump(targets.inject(&:deep_merge), file)
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
