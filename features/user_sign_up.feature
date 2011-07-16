Feature: Signing up new users
  
  Scenario: Register a new user
    Given I go to the sign up page
     When I fill in "user_first_name" with "John"
      And I fill in "user_last_name" with "Doe"
      And I fill in "user_email" with "john.doe@example.net"
      And I fill in "user_password" with "mysecret"
      And I fill in "user_password_confirmation" with "mysecret"
      And I press "Sign up" within "form#user_new"
     Then I should see "User registration complete"
  
  Scenario: Blank sign up form can not be submitted
    Given I go to the sign up page
     When I press "Sign up" within "form#user_new"
     Then I should see "errors"
    
