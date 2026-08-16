Feature: Coins and Rewards
  Children earn coins for correct answers and lesson completion.

  Scenario: Earn coin on first-try correct (8.1)
    Given a child profile "child1" exists
    And the child has 10 coins
    When the child answers an exercise correctly on the first try
    Then the child's coin balance increases to 11

  Scenario: Earn 5 coins for completing a lesson (8.2)
    Given a child profile "child1" exists
    And the child has 10 coins
    When the child completes a lesson for skill "eng.letters.names" with all incorrect first tries
    Then the child earns at least 5 bonus coins for lesson completion

  Scenario: Cannot buy item without enough coins (8.6)
    Given a child profile "child1" exists
    And the child has 5 coins
    When the child tries to buy a shop item costing 20 coins
    Then the purchase is blocked
