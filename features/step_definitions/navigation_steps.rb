require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# These are default commands

Given /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
end

When /^I click "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^I click "([^\"]*)" with text "([^\"]*)"$/ do |link, text|
  click_link(link)
  # find(link, :text => text).trigger("click")
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I fill in "([^\"]*)" for "([^\"]*)"$/ do |value, field|
  fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^I select "([^\"]*)" from "([^\"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^I check "([^\"]*)"$/ do |field|
  check(field)
end

When /^I uncheck "([^\"]*)"$/ do |field|
  uncheck(field)
end

When /^I choose "([^\"]*)"$/ do |field|
  choose(field)
end

Then /^I should see "([^\"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see "([^\"]*)" in "([^\"]*)"$/ do |text, id|
  div = find(:xpath, '//*[@id="' +id + '"]')
  div.should have_content(text)
end

Then /^I should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  page.should have_content(regexp)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^I should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  page.should_not have_content(regexp)
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should =~ /#{value}/
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should_not =~ /#{value}/
end

Then /^the "([^\"]*)" checkbox should be checked$/ do |label|
  find_field(label).should be_checked
end

Then /^the "([^\"]*)" checkbox should not be checked$/ do |label|
  find_field(label).should_not be_checked
end

Then /^I should be on (.+)$/ do |page_name|
  current_path.should == path_to(page_name)
end

Then /^page should have (.+) message "([^\"]*)"$/ do |type, text|
  page.has_css?("p.#{type}", :text => text, :visible => true)
end

# Here be own tests

Given /^there is data in the database$/ do
  FactoryGirl.reload
  FactoryGirl.create(:topic)
  FactoryGirl.create(:repository)
  for i in 0..12
    FactoryGirl.create(:author)
    FactoryGirl.create(:commit)
    FactoryGirl.create(:user)
    FactoryGirl.create(:post)
    FactoryGirl.create(:post_user_one)
    FactoryGirl.create(:gerrit_change)
    FactoryGirl.create(:gerrit_owner)
  end
end

Given /^I have logged in$/ do
  visit path_to("the login page")
  fill_in('username', :with => 'tunnus')
  fill_in('password', :with => 'passu')
  click_button('Log in')
end

When /^I log in successfully$/ do
  visit path_to("the login page")
  fill_in('username', :with => 'tunnus')
  fill_in('password', :with => 'passu')
  click_button('Log in')
end

When /^I try to log in with wrong password$/ do
  visit path_to("the login page")
  fill_in('username', :with => 'tunnus')
  fill_in('password', :with => 'salis')
  click_button('Log in')
end

When /^I hover mouse over a slice on piechart$/ do
  all(".nv-slice")[0].hover
  # all('//div[@class="nv-slice"]')[0].hover
end

When /^I click a slice on piechart$/ do
  all(".nv-slice")[0].click
end

When /^I limit authors to (.+)$/ do |amount|
  fill_in 'time', :with => '01/01/2014'
  fill_in 'amount', :with => amount
  click_button('Limit data')
end

When /^I limit commit count to start from (.+)$/ do |time|
  fill_in 'time', :with => time
  fill_in 'amount', :with => 100
  click_button('Limit data')
end

Then /^show page$/ do
  save_and_open_page
end

Then /^there should be a piechart$/ do
  expect(page).to have_css(".nvd3-svg")
  find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
end

Then /^there should be a barchart$/ do
  expect(page).to have_css(".nvd3-svg")
  find(:xpath, '//*[@class="nvd3 nv-wrap nv-discreteBarWithAxes"]')
end

#gerrit chart tests
Then /^I should see a pie chart with change owner data$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("testOwner1")
end

Then /^I should see a bar chart with change owner data$/ do
  #div with bar chart y axis data
  div = find(:xpath, '//*[@class="nv-groups"]')
  div.should have_content("0")
  div.should have_content("1")
  div.should_not have_content("2")
end

Then /^I should see a bar chart with change revision data$/ do
  div = find(:xpath, '//*[@id="ChangeRevisionsBarChart"]//*[@class="nv-groups"]')
  div.should have_content("0")
  div.should have_content("13")
  div.should_not have_content("2")
end

Then /^I should see a bar chart with change time to pass data$/ do
  div = find(:xpath, '//*[@id="ChangeTimeToPassBarChart"]//*[@class="nv-groups"]')
  div.should have_content("0")
  div.should have_content("13")
  div.should_not have_content("2")
end

Then /^I should see a pie chart with change owner domains$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("email")
end

Then /^I should see average time and revisions for a change to pass$/ do
  page.should have_content("Average time for a change to pass CI: 0 days, 1 hours, 0 minutes and 0 seconds.")
  page.should have_content("Average revisions needed for a change to pass CI: 0")
end

#git chart tests
Then /^I should see a pie chart of git committers$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("testAuthor13")
  div.should have_content("testAuthor2")
end

Then /^I should see a pie chart with one git committer$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("testAuthor13")
  div.should_not have_content("testAuthor2")
  div.should_not have_content("testAuthor12")
end

Then /^I should not see git committers$/ do
  page.should_not have_content("testAuthor")
end

Then /^I should see a bar chart of git committers$/ do
  div = find(:xpath, '//*[@class="nv-groups"]')
  div.should have_content("0")
  div.should have_content("13")
  div.should_not have_content("2")
end

Then /^I should see a bar chart with 2 git committers$/ do
  div = find(:xpath, '//*[@class="nv-groups"]')
  div.should have_content("0")
  div.should_not have_content("1")
  div.should have_content("2")
end

Then /^I should see a pie chart of committer domains$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("test")
end

Then /^I should not see committer domains$/ do
  page.should_not have_content("test")
end

Then /^there should be a barchart with post data$/ do
  find(:xpath, '//*[@class="nvd3 nv-wrap nv-discreteBarWithAxes"]')
  expect(page).to have_content("Users by postcount") #title
  expect(page).to have_content("12")
  expect(page).to have_content("3-5")
end

Then /^I should see a pie chart of email providers$/ do
  div = find(:xpath, '//*[@class="nvd3 nv-wrap nv-pieChart"]')
  div.should have_content("test")
end

Then /^there should be proper labels on the post barchart$/ do
  expect(page).to have_content("Users") #labels
  expect(page).to have_content("Posts")
end

Then /^I should see some email provider users$/ do
  page.all(:xpath, '//div[@class="nvtooltip xy-tooltip nv-pointer-events-none"]//p').count.should be >= 2
end

Then /^I should see email users as a list$/ do
  emailProvider = all(".nv-slice")[0].text
  page.should have_content("Users with " + emailProvider)
  all(:xpath, '//div[@id="usernames"]//ul//li')[0].text.should == "testUser1"
  all(:xpath, '//div[@id="usernames"]//ul//li')[1].text.should == "testUser2"
end

Then /^I should be on user's forum page$/ do
  switch_to_window(window_opened_by { all(".nv-slice")[0].click })
  forumPage = current_url
  switch_to_window(windows.first)
  visit path_to("forum_charts")
  click_button("Users")
  all(".nv-slice")[0].hover
  forumPage.should == "http://forum.qt.io/user/" + find(".key").text
end
