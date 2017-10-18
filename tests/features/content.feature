Feature: Content
  In order to test some basic Behat functionality
  As a website user
  I need to be able to see that the Drupal and Drush drivers are working

# TODO: 'Given ... content' (below) works, but 'When I am viewing ... content'
# uses data that pantheonssh rejects

#  @api
#  Scenario: Create a node
#    Given I am logged in as a user with the "administrator" role
#    When I am viewing an "article" content with the title "My article"
#    Then I should see the heading "My article"

  @api
  Scenario: Create many nodes
    Given "page" content:
    | title    |
    | Page one |
    | Page two |
    And "article" content:
    | title          |
    | First article  |
    | Second article |
