require 'pry'
require 'pry-nav'
require 'yaml'

require_relative '../../features/support/helper'

Given(/^I am on the homepage$/) do
  find(".itriage_logo")
end

Then(/^I see a title with the text "(.*?)"$/) do |text|
  has_title?(/#{text}/)
end

Then(/^I click a link to the <page_label> page I am taken to <page_uri>$/) do |table|
  table.raw.each_with_index do |row, _index|
    link_text = row[0]
    link_uri = row[1]

    link = page.find(:xpath, "//a[@href='#{link_uri}']")

    message = "expected link text #{link_text} did not match actual text #{link.text} for link with href #{link_uri}"
    fail message unless link.text.eql? link_text

    fail "link to #{link_name} was not visible" unless link.visible?

    referrer_url = page.current_url
    link.click
    begin
      sleep 3
      wait_until { !referrer_url.eql?(page.current_url) }
    rescue Selenium::WebDriver::Error::TimeOutError => e
      log = Logger.new(STDOUT)
      log.info "TimeOutError at #{page.current_url}"
    end

    message = "clicking the #{link_text} link resulted in #{page.current_url} instead of expected: #{link_uri}"
    fail message unless page.current_url.gsub(SERVER_URL,'').eql? link_uri
  end
end

Given(/^I click the login link$/) do
  link = page.find(:xpath, "//a[@id='login']")
  link.click
end

And(/^I submit correct login credentials$/) do

  # using a YAML file for potentially volatile form data (such as logins) in case it needs to be quickly changed
  login_data = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../support/form_data.yml'))
  email_address = login_data['login_credentials'][:email_address]
  password = login_data['login_credentials'][:password]

  # using class in the element locator enforces that CSS class -
  # consult with dev team RE: elements that dont have an ID parameter
  email_field = page.find(:xpath, "//input[@class='form-email']")
  password_field = page.find(:xpath, "//input[@class='form-password' and @type='password']")

  # xpath contains() is useful for locating an element that matches a single CSS class within its class attribute
  # any other classes besides submit-button will be ignored
  login_button = page.find(:xpath, "//*[contains(@class,'submit-button') and @type='submit']")

  email_field.set email_address
  password_field.set password

  login_button.click
end

Then(/^I should see a logout link$/) do
  sleep 3

  logout_xpath = "//a[@id='logout']"
  logout_link = wait_until { page.find(:xpath, logout_xpath) }

  # rspec expectations can be an alternative to the 'fail(msg) unless' type check
  expect(page).to have_xpath(logout_xpath)

  # "fail unless" syntax allows for control over the conditions that result in an exception
  fail "logout link as not visible after logging in" unless logout_link.visible?
end

Given(/^I click the logout link$/) do
  sleep 2
  logout_xpath = "//a[@id='logout']"
  logout_link = wait_until { page.find(:xpath, logout_xpath) }

  logout_link.click
end

Then(/^I should see a login link$/) do
  sleep 3

  login_xpath = "//a[@id='login']"
  login_link = wait_until { page.find(:xpath, login_xpath) }

  expect(page).to have_xpath(login_xpath)
  fail "login link as not visible after logging out" unless login_link.visible?
end

Given(/^I submit incorrect login credentials$/) do
  login_data = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../support/form_data.yml'))
  wrong_email_address = login_data['invalid_credentials'][:email_address]
  wrong_password = login_data['invalid_credentials'][:password]

  email_field = page.find(:xpath, "//input[@class='form-email']")
  password_field = page.find(:xpath, "//input[@class='form-password' and @type='password']")

  email_field.set wrong_email_address
  password_field.set wrong_password

  login_button = page.find(:xpath, "//*[contains(@class,'submit-button') and @type='submit']")
  login_button.click

  sleep 2
  invalid_msg_xpath = "//*[contains(text(),'Invalid Credentials')]"
  invalid_msg_element = wait_until { page.find(:xpath, invalid_msg_xpath) }

  expect(page).to have_xpath(invalid_msg_xpath)
  fail "Invalid Credentials message was not visible after submitting incorrect login" unless invalid_msg_element.visible?
end