Feature: Mastery and Leitner Scheduling
  Items progress through Leitner boxes with spaced repetition intervals.

  Scenario: New item starts at box 0 (7.1)
    Given a child profile "child1" exists
    When the item "eng.letters.names.001" has never been seen
    Then its Leitner box level is 0

  Scenario: Correct first-try moves item up one box (7.2)
    Given a child profile "child1" exists
    And item "eng.letters.names.001" is at box level 2
    When the child answers it correctly on the first try
    Then the item moves to box level 3
    And the next review due date is 4 days from today

  Scenario: Incorrect answer drops item to box 1 (7.3)
    Given a child profile "child1" exists
    And item "eng.letters.names.001" is at box level 4
    When the child answers it incorrectly on the first try
    Then the item drops to box level 1
    And the next review due date is 1 day from today

  Scenario: Leitner box review intervals (7.4)
    Given items exist at each box level
    When the system calculates due dates
    Then box 1 items are due in 1 day
    And box 2 items are due in 2 days
    And box 3 items are due in 4 days
    And box 4 items are due in 8 days
    And box 5 items are due in 16 days

  Scenario: Skill mastery percentage calculation (7.5)
    Given a child profile "child1" exists
    And skill "eng.letters.names" has items with various box levels
    When mastery is calculated for skill "eng.letters.names"
    Then the mastery percentage reflects items at box 3 or above divided by total items
