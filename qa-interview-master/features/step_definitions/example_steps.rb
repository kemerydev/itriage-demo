require 'pry'
require 'pry-nav'

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

And(/^I enter correct login credentials$/) do
  login_data = YAML.load_file('support/form_data.yml')["login_credentials"]
end
