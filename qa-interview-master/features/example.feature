Feature: An Example Feature

  Background:
    Given I am on the homepage
    Then  I see a title with the text "iTriageHealth.com"

  Scenario: Validate that the home page links navigate to the correct pages
    When I click a link to the <page_label> page I am taken to <page_uri>
      | Doctors     | /doctors         |
      | Facilities  | /facilities      |
      | Conditions  | /conditions      |
      | Medications | /medications     |
      | Procedures  | /procedures      |
      | News        | /news/categories |

  Scenario: User is able to log in from the home screen with correct credentials
    Given I click the login link
    And I submit correct login credentials
    Then I should see a logout link
    Given I click the logout link
    Then I should see a login link

  Scenario: Unable to login from the home screen with incorrect credentials
    Given I click the login link
    And I submit incorrect login credentials

  Scenario: Navigate to a hospital and return the hospital name and zip code

  Scenario: Search for Family Practice Doctors, in Atka, AK

  Scenario: Print the list of physicians from search results