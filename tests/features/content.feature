Feature: Content
  In order to test some basic Behat functionality
  As a website user
  I need to be able to see that the Drupal and Drush drivers are working

  @homepage
  Scenario: Test the homepage
    When I go to "/"
    Then I should see "Welcome to CI Tutorial"

  @api @loggedin
  Scenario: Logged in as an Administrator
    Given I am logged in as a user with the "administrator" role
      When I go to "/"
      Then I should see "Log out"
