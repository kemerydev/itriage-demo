require 'rubygems'
require 'bundler/setup'
require 'capybara/cucumber'
require 'capybara-screenshot'
require 'selenium-webdriver'
require 'page-object'

require 'pry'

SERVER_URL  ||= 'https://www.itriagehealth.com'
WEB_BROWSER ||= :firefox

Capybara.register_driver WEB_BROWSER do |app|
  Capybara::Selenium::Driver.new(app, browser: WEB_BROWSER)
end

Capybara.configure do |config|
  config.default_driver = WEB_BROWSER
  config.app_host = SERVER_URL
end

Capybara.save_and_open_page_path = ENV['SCREENSHOT_PATH']

Capybara::Screenshot.register_driver(WEB_BROWSER) do |driver, path|
  driver.browser.save_screenshot(path)
end

# HOOKS
Before do |scenario|
  visit 'https://www.itriagehealth.com'
end

After do |scenario|
end