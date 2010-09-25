
Given /^I have not previously authorized$/ do
  @user = Customer.new
end

When /^I authorize with Twitter$/ do
  visit oauth_callback_path
end

Then /^I should be authorized$/ do
  pending # express the regexp above with the code you wish you had
end

