# Given /^the following user_sign_ups:$/ do |user_sign_ups|
#   UserSignUp.create!(user_sign_ups.hashes)
# end

# When /^I delete the (\d+)(?:st|nd|rd|th) user_sign_up$/ do |pos|
#   visit user_sign_ups_path
#   within("table tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end

# Then /^I should see the following user_sign_ups:$/ do |expected_user_sign_ups_table|
#   expected_user_sign_ups_table.diff!(tableish('table tr', 'td,th'))
# end

