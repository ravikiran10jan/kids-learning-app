Feature: Lesson Flow
  Lessons are composed of 8-12 exercises with a 50/30/20 ratio of new/review/mistake items.

  Scenario: Lesson loads with exercises (3.1)
    Given a child profile "child1" exists
    When the child starts a lesson for skill "eng.letters.names"
    Then the lesson contains between 1 and 12 exercises
    And the lesson has an id and skill id

  Scenario: Lesson completion awards coins (3.6)
    Given a child profile "child1" exists
    And the child starts a lesson for skill "eng.letters.names"
    When the child completes the lesson with all first-try correct answers
    Then the child earns coins equal to exercise count plus 5 bonus

  Scenario: Exit lesson requires confirmation (3.7)
    Given a child profile "child1" exists
    And the child has started a lesson
    When the child attempts to exit the lesson
    Then the lesson state is preserved until confirmed

  Scenario: Adaptive difficulty - high accuracy (3.8)
    Given a child profile "child1" exists
    And the child completed a lesson with first-try accuracy above 90%
    When the next lesson is composed
    Then the next lesson is successfully composed with available items

  Scenario: Subject interleaving between lessons (3.10)
    Given a child profile "child1" exists
    And the child just completed an English lesson
    When the system checks whether to suggest alternate subject
    Then the system suggests an alternate subject
