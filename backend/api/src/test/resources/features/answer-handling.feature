Feature: Answer Handling and No-Fail Loop
  Correct answers earn coins, incorrect answers get gentle retry with hints.

  Scenario: First-try correct earns a coin (4.2)
    Given a child profile "child1" exists
    When the child answers exercise "eng.letters.names.001" correctly on the first try
    Then the item progress box level increases by 1
    And the child earns 1 coin for first-try correct

  Scenario: First incorrect attempt drops to box 1 (5.1)
    Given a child profile "child1" exists
    And item "eng.letters.names.001" is at box level 3
    When the child answers the item incorrectly
    Then the item progress box level drops to 1
    And no score penalty is applied
    And the item is added to the mistake queue

  Scenario: Child always ends on a correct action (5.3)
    Given a child profile "child1" exists
    And the child answered an item incorrectly twice
    When the correct answer is shown and the child taps it
    Then the lesson advances to the next exercise

  Scenario: No way to lose or fail a lesson (5.6)
    Given a child profile "child1" exists
    When the child completes a lesson answering every exercise incorrectly on first try
    Then the lesson completes normally
    And the child still earns 5 bonus coins for completion

  Scenario: Mistake item added to mistake queue (5.5)
    Given a child profile "child1" exists
    When the child answers item "eng.letters.names.001" incorrectly
    Then item "eng.letters.names.001" is in the mistake queue
