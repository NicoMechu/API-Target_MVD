# encoding: utf-8

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.2'

# Use postgres as the database for Active Record
gem 'pg', '~> 0.18.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'activeadmin', '~> 1.0.0.pre1'
gem 'annotate', '~> 2.6.5'
gem 'devise', '~> 3.5.1'
gem 'devise-async', '~> 0.10.1'

# Use delayed jobs
gem 'delayed_job_active_record', '~> 4.0.3'

gem 'haml', '~> 4.0.6'
gem 'jbuilder', '~> 1.2'
gem 'koala', '~> 1.10.0rc'
gem 'rails_12factor', '~> 0.0.3', group: :production
gem 'simple_token_authentication', '~> 1.6.0'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'dotenv', '~> 2.0.2'

  # Code analysis tools
  gem 'rails_best_practices'
  gem 'reek', '~> 1.3.6'
  gem 'rubocop', '~> 0.19.0'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.3'
  gem 'rspec-rails', '~> 3.3.2'
  gem 'spork-rails', '~> 4.0.0'
  gem 'thin', '~> 1.6.3'
end

group :test do
  gem 'database_cleaner', '~> 1.4.1'
  gem 'shoulda-matchers', '~> 2.8.0'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
