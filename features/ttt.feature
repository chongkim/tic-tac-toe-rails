Feature: Displays a tic-tac-toe board and plays a game

  Background:
    Given I visit the home page

  @javascript
  Scenario:
    Then I should have selector "#ttt"
    And I should see content "Who do you want to play first"

  @javascript
  Scenario:
    When I click on button "Human First"
    Then I should have selector "#t-0"
  
  @javascript
  Scenario:
    When I click on button "Human First"
    And I click on selector "#t-0"
    Then I should have content "o" on "#t-1"
