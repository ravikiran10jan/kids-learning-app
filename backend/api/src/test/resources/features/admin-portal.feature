Feature: Admin Portal Content Management
  The admin portal allows CRUD operations on curriculum content via REST API.

  Scenario: Create a new unit (20.1)
    Given the admin portal is running
    When the admin creates a unit with code "E9" and title "New Unit"
    Then the unit is persisted
    And the unit appears in the units list

  Scenario: Create a new skill within a unit (20.2)
    Given the admin portal is running
    When the admin creates a skill with id "eng.new.skill" in unit "E1"
    Then the skill is persisted
    And the skill appears in the skills list

  Scenario: Edit an existing skill (20.3)
    Given the admin portal is running
    When the admin updates skill "eng.letters.names" with new title "Updated Letter Names"
    Then the skill title is updated to "Updated Letter Names"

  Scenario: Delete a skill (20.4)
    Given the admin portal is running
    When the admin deletes skill "eng.letters.names"
    Then the skill is removed from the system

  Scenario: Browse and filter items (21.1)
    Given the admin portal is running
    When the admin requests all items for skill "eng.letters.names"
    Then a list of items is returned

  Scenario: Create a new item via form (21.2)
    Given the admin portal is running
    When the admin creates a new pick_text item for skill "eng.letters.names"
    Then the item is persisted and available

  Scenario: Preview an exercise (21.5)
    Given the admin portal is running
    When the admin previews item "eng.letters.names.001"
    Then the item details are returned including prompt, answer, and distractors

  Scenario: Bulk import items from JSON (23.1)
    Given the admin portal is running
    When the admin imports a valid JSON with 3 items
    Then 3 items are imported successfully

  Scenario: Export all content as JSON (23.3)
    Given the admin portal is running
    When the admin exports all content
    Then the export contains units, skills, and items

  Scenario: Content health report (22.5)
    Given the admin portal is running
    When the admin requests a content health check
    Then a health report is returned with content statistics

  Scenario: Content versioning (24.2)
    Given the admin portal is running
    When the admin increments the content version
    Then the content version is increased by 1
