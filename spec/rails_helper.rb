ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/webkit'
require 'capybara-screenshot/rspec'
require 'factory_girl'
require 'factory_girl_rails'
require 'devise'
require 'simplecov'
require 'simplecov-json'
require 'simplecov-rcov'
require 'capybara/poltergeist'
require 'site_prism'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::RcovFormatter
]

SimpleCov.start 'rails'


ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods
  config.include SessionHelpers, type: :feature
  config.include FillFormsHelpers, type: :feature

  config.order = :random

  config.infer_spec_type_from_file_location!

  Warden.test_mode!
  config.after :each do
    Warden.test_reset!
  end

  if config.filter_manager.inclusions[:ci]
    Capybara.javascript_driver = :poltergeist
    config.filter_manager.inclusions.delete(:ci)
  else
    Capybara.javascript_driver = :webkit
  end

  Capybara.ignore_hidden_elements = true

  config.use_transactional_fixtures = false

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
