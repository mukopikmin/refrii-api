# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.10.9'
gem 'bcrypt', '~> 3.1.12'
gem 'config', '~> 1.7.1'
gem 'dotenv-rails', '~> 2.7.2'
gem 'ffaker', '~> 2.11.0'
gem 'google-cloud-storage', '~> 1.18'
gem 'jwt', '~> 2.1.0'
gem 'mini_magick', '~> 4.9'
gem 'paper_trail', '~> 10.3.0'
gem 'paper_trail-association_tracking', '~> 2.0.0'
gem 'puma', '~> 3.12.1'
gem 'rack-cors', '~> 1.0.3'
gem 'rails', '~> 5.2.3'
gem 'rest-client', '~> 2.0.2'
gem 'rubocop', '~> 0.67.2', require: false
gem 'rubocop-rspec', '~> 1.32.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'versionist', '~> 1.7.0'

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :development, :test do
  gem 'byebug', '~> 11.0.1', platform: :mri
  gem 'rspec-rails', '~> 3.8.2'
  gem 'sqlite3'
end

group :test do
  gem 'brakeman', '~> 4.5.0', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.9', require: false
  gem 'committee', '~> 3.0.1'
  gem 'committee-rails', '~> 0.4.0'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.0.1'
  gem 'rails-controller-testing', '~> 1.0.4'
end

group :production do
  gem 'pg', '~> 1.1.4'
  gem 'rails_12factor', '~> 0.0.3'
end
