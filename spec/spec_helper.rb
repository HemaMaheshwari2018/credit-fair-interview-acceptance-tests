require 'selenium/webdriver'
require 'capybara/rspec'
require 'faker'
require 'nokogiri'
require 'open-uri'
require 'require_all'
require 'site_prism'
require 'rspec/retry'
require 'capybara'
require 'rspec'
require 'json'
require 'bundler/setup'
require 'yarjuf'
require_all './spec/helpers'
require_all './page_object'
require_all './spec/support'


Capybara.default_selector = :css

RSpec.configure do |config|
  puts '****** I am called rspec config*******'
  puts ENV['browserName']
  config.include Capybara::DSL
  config.include Helpers
  config.include PageObjects
  config.include Capybara::RSpecMatchers
  config.include WaitForAjax
  config.color = true
  config.tty = true
  config.default_formatter = 'doc'


config.before :each do |scenario|
  Capybara.reset_sessions!
  Capybara.default_selector = :css
  Capybara.configure do |config|


  config.default_max_wait_time = 40
  config.app_host = ENV['app_host']
  config.run_server = false
  config.javascript_driver = :remote_browser
  Capybara.default_driver =:selenium
  Capybara.register_driver :selenium do |app|
       Capybara::Selenium::Driver.new(app, :browser => ENV['browserName'].to_sym)
  end
  end
end

  config.after :each do
    Capybara.current_session.driver.quit
  end
end

