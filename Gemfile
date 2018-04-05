source 'https://rubygems.org'

ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.10'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors', '~> 1.0.1'
gem 'active_model_serializers', '~> 0.10.5'
gem 'dotenv-rails', '~> 2.2.0'
gem 'ffaker', '~> 2.8.1'
gem 'omniauth', '~> 1.8.1'
gem 'rmagick', '~> 2.16.0'
gem 'config', '~> 1.7.0'
gem 'omniauth-auth0', '~> 2.0.0'
gem 'omniauth-oauth2', '~> 1.5.0'
gem 'omniauth-google-oauth2', '~> 0.5.0'
gem 'paper_trail', '~> 9.0.0'
gem 'rest-client', '~> 2.0.2'
gem 'hashie', '~> 3.5.6'
gem 'versionist', '~> 1.7.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', '~> 10.0.0', platform: :mri
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.7.2'
end

group :test do
  gem 'database_cleaner', '~> 1.6.1'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'codeclimate-test-reporter', '~> 1.0.8', require: false
  gem 'brakeman', '~> 4.2.0', require: false
end

group :production do
  gem 'pg', '~> 1.0.0'
  gem 'rails_12factor', '~> 0.0.3'
end
