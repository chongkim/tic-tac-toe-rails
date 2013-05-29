Given(/^I visit the home page$/) do
  visit('/')
end

Then(/^I should have selector "(.*?)"$/) do |selector|
  page.should have_selector(selector)
end

Then(/^I should see content "(.*?)"$/) do |content|
  page.should have_content(content)
end

When(/^I click on button "(.*?)"$/) do |button|
  click_button button
end

When(/^I click on selector "(.*?)"$/) do |selector|
  find(selector).click
end

Then(/^I should have content "(.*?)" on "(.*?)"$/) do |content, selector|
  find(selector).should have_content(content)
end
