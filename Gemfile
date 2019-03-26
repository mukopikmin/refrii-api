# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.10.8'
gem 'bcrypt', '~> 3.1.12'
gem 'config', '~> 1.7.0'
gem 'dotenv-rails', '~> 2.5.0'
gem 'ffaker', '~> 2.10.0'
gem 'jwt', '~> 2.1'
gem 'omniauth', '~> 1.8.1'
gem 'omniauth-auth0', '~> 2.0.0'
gem 'omniauth-google-oauth2', '~> 0.5.3'
gem 'omniauth-oauth2', '~> 1.5.0'
gem 'paper_trail', '~> 10.0.1'
gem 'paper_trail-association_tracking', '~> 1.0.0'
gem 'puma', '~> 3.12.0'
gem 'rack-cors', '~> 1.0.2'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'rest-client', '~> 2.0.2'
gem 'rmagick', '~> 2.16.0'
gem 'rubocop', '~> 0.59.2', require: false
gem 'rubocop-rspec', '~> 1.30.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'versionist', '~> 1.7.0'

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :development, :test do
  gem 'byebug', '~> 10.0.2', platform: :mri
  gem 'rspec-rails', '~> 3.8.2'
  gem 'sqlite3'
end

group :test do
  gem 'brakeman', '~> 4.3.1', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.9', require: false
  gem 'committee', '~> 2.5.1'
  gem 'committee-rails', '~> 0.4.0'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'rails-controller-testing', '~> 1.0.4'
end

group :production do
  gem 'pg', '~> 1.1.3'
  gem 'rails_12factor', '~> 0.0.3'
end
