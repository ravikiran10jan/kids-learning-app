Feature: Parent Mode Controls and Settings
  Behind a gate, parents can view progress and control settings.

  Scenario: View mastery per skill (12.1)
    Given a child profile "child1" exists
    When the parent requests dashboard data for "child1"
    Then the dashboard contains skill mastery percentages
    And the dashboard contains first-try accuracy

  Scenario: View trouble spots (12.4)
    Given a child profile "child1" exists
    And the child has answered some items incorrectly multiple times
    When the parent requests trouble spots for "child1"
    Then the trouble spots list is returned sorted by miss count

  Scenario: Enable or disable units (13.1)
    Given a child profile "child1" exists
    When the parent disables unit "E2" for "child1"
    Then unit "E2" is in the child's disabled units list

  Scenario: Force unlock a skill (13.2)
    Given a child profile "child1" exists
    When the parent force-unlocks a skill
    Then the skill becomes available regardless of prerequisites

  Scenario: Reset a skill (13.3)
    Given a child profile "child1" exists
    And the child has progress on skill "eng.letters.names"
    When the parent resets skill "eng.letters.names"
    Then all item progress for that skill is set back to box 0

  Scenario: Set daily goal (13.4)
    Given a child profile "child1" exists
    When the parent sets the daily goal to 3 lessons
    Then the child's daily goal is updated to 3 lessons

  Scenario: Set weekly goal (13.5)
    Given a child profile "child1" exists
    When the parent sets the weekly goal to 5 days
    Then the child's weekly goal is updated to 5 days

  Scenario: Export progress to JSON (14.1)
    Given a child profile "child1" exists
    When the parent exports progress for "child1"
    Then valid JSON is returned containing profile and progress data

  Scenario: Wipe all data (14.2)
    Given a child profile "child1" exists
    And the child has progress and coins
    When the parent wipes all data for "child1"
    Then the profile is reset to a fresh state with zero progress
