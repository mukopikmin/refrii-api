# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.10.10'
gem 'bcrypt', '~> 3.1.13'
gem 'config', '~> 2.0.0'
gem 'dotenv-rails', '~> 2.7.5'
gem 'ffaker', '~> 2.13.0'
gem 'google-cloud-storage', '~> 1.24.0'
gem 'jwt', '~> 2.2.1'
gem 'mini_magick', '~> 4.9.5'
gem 'paper_trail', '~> 10.3.1'
gem 'paper_trail-association_tracking', '~> 2.0.0'
gem 'puma', '~> 4.3.8'
gem 'rack-cors', '~> 1.1.0'
gem 'rails', '~> 6.0.1'
gem 'rest-client', '~> 2.1.0'
gem 'rubocop', '~> 0.77.0', require: false
gem 'rubocop-rspec', '~> 1.37.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'versionist', '~> 2.0.1'

group :development do
  gem 'listen', '~> 3.2.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :development, :test do
  gem 'byebug', '~> 11.0.1', platform: :mri
  gem 'rspec-rails', '~> 3.9.0'
  gem 'sqlite3'
end

group :test do
  gem 'committee', '~> 3.3.0'
  gem 'committee-rails', '~> 0.4.0'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'simplecov', '~> 0.17.1'
end

group :production do
  gem 'mysql2', '~> 0.5.3'
  gem 'rails_12factor', '~> 0.0.3'
end
