require 'rubygems'
require 'spork'

ENV["SERVER_PORT"] ||= "8200"

Spork.prefork do
  require 'cucumber/rails'

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  Capybara.default_wait_time = 10
  Capybara.server_port = ENV["SERVER_PORT"]
  Capybara.app_host = "http://lvh.me:#{ENV['SERVER_PORT']}"

  # require 'capybara/poltergeist'
  # Capybara.javascript_driver = :poltergeist

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  ActionController::Base.allow_rescue = false

  begin
    DatabaseCleaner.strategy = :truncation
    Cucumber::Rails::Database.javascript_strategy = :truncation
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end
end

Spork.each_run do
end
