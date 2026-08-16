Feature: Skill Path Navigation
  The child navigates skills on a winding path, unlocking them through mastery.

  Scenario: Path displays skill nodes in order (2.1)
    Given a child profile "child1" exists
    When the child requests skills for subject "ENGLISH"
    Then the skills are returned in order
    And skills without prerequisite mastery are indicated as locked

  Scenario: Skill unlocks when prerequisite reaches 80% mastery (2.5)
    Given a child profile "child1" exists
    And skill "eng.letters.sounds" has prerequisite "eng.letters.names"
    And the child has 80% or more mastery on skill "eng.letters.names"
    When the system checks if skill "eng.letters.sounds" is unlocked
    Then the skill "eng.letters.sounds" is unlocked

  Scenario: Skill node turns gold at 80% mastery (2.6)
    Given a child profile "child1" exists
    And 80% or more items in skill "eng.letters.names" are at Leitner box level 3 or above
    When the system calculates mastery for skill "eng.letters.names"
    Then the mastery percentage is 80.0 or above

  Scenario: Locked skill cannot be opened (2.4)
    Given a child profile "child1" exists
    And skill "eng.letters.sounds" has prerequisite "eng.letters.names"
    And the child has 0% mastery on skill "eng.letters.names"
    When the system checks if skill "eng.letters.sounds" is unlocked
    Then the skill "eng.letters.sounds" is locked
