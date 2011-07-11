Feature: Signing up new users
  In order to avoid regression errors
  As a developer
  I want to registration form works anytime
  
  Scenario: Register new user
    Given I am on the new sign_up page
    And I fill in 'First name' with "John"
    And I fill in 'Last name' with "Doe"
    And I fill in 'Email' with "john.doe@example.net"
    And I fill in 'Password' with "mysecret"
    And I fill in 'Password confirmation' with "mysecret"
    And I press "Sign up"
    Then the result should be "User registration complete" on the screen
  
  Scenario: Cannot submit blank form
    Given I am on the new sign_up page
    And I press "Sign up"
    Then the result should be "errors" on the screen
    
