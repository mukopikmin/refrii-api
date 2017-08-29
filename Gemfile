source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rack-cors', '~> 0.4.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'sqlite3'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.6.1'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'codeclimate-test-reporter', '~> 1.0.8', require: false
  gem 'brakeman', '~> 3.7.0', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 3.6.0'
end

group :production do
  gem 'pg', '~> 0.21.0'
  gem 'rails_12factor', '~> 0.0.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_model_serializers', '~> 0.10.5'
gem 'dotenv-rails', '~> 2.2.0'
gem 'ffaker', '~> 2.6.0'

gem 'omniauth', '~> 1.6.1'
gem 'omniauth-google-oauth2', '~> 0.5.0'

gem 'rmagick', '~> 2.16.0'
gem 'config', '~> 1.4.0'
gem 'omniauth-auth0', '~> 2.0.0'
gem 'omniauth-oauth2', '~> 1.4.0'

gem 'rest-client', '~> 2.0.2'
gem 'hashie', '~> 3.5.6'