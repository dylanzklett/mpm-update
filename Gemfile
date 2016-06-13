source 'https://rubygems.org'
ruby `cat .ruby-version`.strip

gem 'rails', '4.2.0'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rails_12factor', group: :production
# gem 'puma'

gem 'anadea-identity'

gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails'
gem 'haml-rails'

gem 'aasm'
gem 'ruby-units'
gem 'draper'
gem 'prawn'

gem 'paperclip'
gem 'ckeditor'

gem 'whenever', :require => false
gem 'unicorn'
gem 'roadie'
gem 'roadie-rails'
gem 'kaminari'
gem 'leipreachan'
gem 'exception_notification'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'soprano', :require => false
  gem 'rvm-capistrano', :require => false
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'

  gem 'pry'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'capybara-screenshot'

  gem 'quiet_assets'
end

group :test do
  gem 'simplecov', :require => false
  gem 'simplecov-json', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'site_prism'
end
