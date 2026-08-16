# Kids Learning App — BDD Scenarios

> **Working title candidates:** Lumini, Sproutling, WonderTrail, TinySpark, PebblePath, Kip & Coin
> (Final name TBD — pick your favorite or suggest your own!)

**Tech Stack:**
- **Child App:** Flutter (mobile/tablet)
- **Backend API:** Spring Boot (REST)
- **Database:** Firebase (Firestore + Storage)
- **Admin Portal:** Web app served by Spring Boot (Thymeleaf or embedded React)

**Format:** Gherkin (Given / When / Then)

---

## Epic 1: Home Screen

### Scenario 1.1: Home screen loads on app launch
```gherkin
Given the app is installed and the child profile exists in Firebase
When the child opens the app
Then the Home screen is displayed
And it shows the pet character
And it shows the current coin count fetched from the backend
And it shows the weekly goal ring (e.g. "3 of 4 days")
And it shows a large "Practice" button
And it shows two subject buttons: an ABC block (English) and a number block (Math)
```

### Scenario 1.2: Weekly goal ring displays correct progress
```gherkin
Given the child has practiced on 3 days this week
And the weekly goal is set to 4 days
When the Home screen is displayed
Then the weekly goal ring shows "3 of 4 days" with a partially filled ring
```

### Scenario 1.3: Weekly goal ring resets on Monday
```gherkin
Given the child practiced on 5 days last week
When it is Monday and the child opens the app
Then the weekly goal ring shows "0 of 4 days"
And the ring is empty
```

### Scenario 1.4: Navigate to English path
```gherkin
Given the child is on the Home screen
When the child taps the ABC block (English) button
Then the English Path screen is displayed
```

### Scenario 1.5: Navigate to Math path
```gherkin
Given the child is on the Home screen
When the child taps the number block (Math) button
Then the Math Path screen is displayed
```

### Scenario 1.6: Start practice from the big Practice button
```gherkin
Given the child is on the Home screen
And at least one skill is unlocked
When the child taps the "Practice" button
Then the app starts a lesson for the current active skill on the path
```

---

## Epic 2: Skill Path Navigation

### Scenario 2.1: Path displays skill nodes in order
```gherkin
Given the child has selected a subject (English or Math)
When the Path screen loads
Then skill nodes are displayed in a vertical winding path
And the current active skill node is large and animated
And subsequent locked nodes are greyed out
```

### Scenario 2.2: Skill node shows icon and label
```gherkin
Given the Path screen is displayed
When the child views a skill node
Then the node shows a picture icon
And a text label appears beneath the icon
```

### Scenario 2.3: Tap an unlocked skill to start a lesson
```gherkin
Given the Path screen is displayed
And a skill node is unlocked (not greyed)
When the child taps the unlocked skill node
Then a lesson starts for that skill
And the Lesson screen is displayed
```

### Scenario 2.4: Locked skill cannot be opened
```gherkin
Given the Path screen is displayed
And a skill node is locked (greyed out)
When the child taps the locked skill node
Then nothing happens
And the skill remains locked
```

### Scenario 2.5: Skill unlocks when prerequisite reaches 80% mastery
```gherkin
Given skill "eng.letters.sounds" has mastery at 80% or above
And skill "eng.shortvowel.a" lists "eng.letters.sounds" as a prerequisite
When the Path screen refreshes
Then skill "eng.shortvowel.a" becomes unlocked
And its node is no longer greyed out
```

### Scenario 2.6: Skill node turns gold at 80% mastery
```gherkin
Given the child has completed items in skill "eng.shortvowel.a"
And 80% or more items are at Leitner box level 3 or above
When the Path screen is displayed
Then the "eng.shortvowel.a" node displays as gold
```

### Scenario 2.7: Mastery never visually regresses
```gherkin
Given skill "eng.shortvowel.a" was previously shown as gold
And the child answers some review items incorrectly in a later session
When the Path screen is displayed again
Then the node does not revert from gold to a lower visual state
```

---

## Epic 3: Lesson Flow

### Scenario 3.1: Lesson loads with 8–12 exercises
```gherkin
Given the child starts a lesson for a skill
When the Lesson screen loads
Then a progress bar is shown at the top
And the lesson contains between 8 and 12 exercises
And the first exercise is displayed in the middle of the screen
And a replay-audio button is visible in a fixed corner
```

### Scenario 3.2: Lesson composition — new, review, and mistake items
```gherkin
Given the child starts a lesson for skill "eng.shortvowel.a"
And the child has items due for review from completed skills
And the child has items in the mistake queue
When the lesson is composed
Then approximately 50% of exercises are new or in-progress items from the current skill
And approximately 30% are items due for review from any completed skill
And approximately 20% are items from the mistake queue
```

### Scenario 3.3: Audio plays automatically on exercise load
```gherkin
Given the child is on an exercise that has audio
When the exercise is displayed
Then the prompt audio plays automatically
And the text equivalent is shown on screen as a support
```

### Scenario 3.4: Replay audio button
```gherkin
Given the child is on an exercise
When the child taps the replay-audio button
Then the prompt audio plays again
```

### Scenario 3.5: Progress bar updates as exercises are completed
```gherkin
Given the child is in a 10-exercise lesson
And the child has completed 4 exercises
When the 5th exercise is displayed
Then the progress bar shows 40% completion
```

### Scenario 3.6: Lesson complete screen is shown after last exercise
```gherkin
Given the child has answered the last exercise in the lesson
When the lesson ends
Then the Lesson Complete screen is displayed
And it shows the number of coins earned
And it offers a mistake replay option
And it shows "One More?" and "Done" buttons
```

### Scenario 3.7: Exit lesson with confirmation
```gherkin
Given the child is in the middle of a lesson
When the child attempts to exit (back button or close)
Then a confirmation dialog is displayed
And the lesson does not exit until confirmed
```

### Scenario 3.8: Adaptive difficulty — high accuracy
```gherkin
Given the child completed a lesson with first-try accuracy above 90%
When the next lesson is composed
Then the next lesson introduces more new items than the default ratio
```

### Scenario 3.9: Adaptive difficulty — low accuracy
```gherkin
Given the child completed a lesson with first-try accuracy below 60%
When the next lesson is composed
Then the next lesson weights toward review items
And fewer new items are introduced
```

### Scenario 3.10: Subject interleaving between lessons
```gherkin
Given the child just completed an English lesson
When the child starts the next lesson from the Home screen
Then the app suggests a Math lesson next
And subjects alternate between lessons (never mixed within one lesson)
```

---

## Epic 4: Answer Handling — Correct Answer

### Scenario 4.1: Correct answer feedback
```gherkin
Given the child is on an exercise
When the child selects the correct answer
Then a chime sound plays
And a green flash animation is shown
And a coin flies to the coin counter
And the app auto-advances to the next exercise after approximately 800ms
```

### Scenario 4.2: First-try correct earns a coin
```gherkin
Given the child is on an exercise
When the child selects the correct answer on the first try
Then 1 coin is added to the child's total
And the coin increment is synced to Firebase via the backend
```

### Scenario 4.3: Lesson completion bonus
```gherkin
Given the child completes all exercises in a lesson
When the Lesson Complete screen is shown
Then 5 bonus coins are added to the child's total
```

---

## Epic 5: Answer Handling — Incorrect Answer & No-Fail Loop

### Scenario 5.1: First incorrect attempt — gentle retry with hint
```gherkin
Given the child is on an exercise
When the child selects an incorrect answer for the first time
Then a gentle sound plays (not a buzzer)
And the wrong choice fades out
And no score penalty is applied
And a hint is displayed (audio replay, a distractor removed, or a visual scaffold)
And the child can try again
```

### Scenario 5.2: Second incorrect attempt — show correct answer
```gherkin
Given the child has already answered incorrectly once on this exercise
When the child selects an incorrect answer for the second time
Then the app shows and explains the correct answer
And the child is asked to tap the correct answer to move on
And the item is added to the mistake queue
```

### Scenario 5.3: Child always ends on a correct action
```gherkin
Given the child has answered incorrectly twice on an exercise
And the correct answer has been shown
When the child taps the correct answer
Then the app advances to the next exercise
And the child's last action on that exercise was correct
```

### Scenario 5.4: Mistake item re-asked at end of lesson
```gherkin
Given the child answered an item incorrectly during the lesson
And the item was added to the mistake queue
When the child reaches the end of the lesson exercises
Then the mistake item is presented again before the lesson completes
```

### Scenario 5.5: Mistake item re-asked in next session
```gherkin
Given the child has items in the mistake queue from a previous session
When the child starts a new lesson
Then mistake queue items are included in the lesson composition (20% allocation)
```

### Scenario 5.6: No way to lose or fail a lesson
```gherkin
Given the child is in a lesson
And the child answers every exercise incorrectly on the first try
When the lesson reaches the end
Then the lesson completes normally
And the Lesson Complete screen is shown
And there is no failure state or punishment
```

---

## Epic 6: Exercise Types

### Scenario 6.1: pick_image exercise
```gherkin
Given the exercise type is "pick_image"
When the exercise loads
Then audio plays stating the prompt (e.g. "Tap the cat")
And 4 pictures are displayed as tappable options
When the child taps the correct picture
Then the correct-answer feedback is triggered
```

### Scenario 6.2: pick_text exercise
```gherkin
Given the exercise type is "pick_text"
When the exercise loads
Then audio plays stating the prompt (e.g. "Which word says jump?")
And 4 word options are displayed as tappable buttons
When the child taps the correct word
Then the correct-answer feedback is triggered
```

### Scenario 6.3: pick_number exercise
```gherkin
Given the exercise type is "pick_number"
When the exercise loads
Then a math question is displayed (e.g. "8 + 5 = ?")
And 4 number tiles are shown as options
When the child taps the correct number
Then the correct-answer feedback is triggered
```

### Scenario 6.4: spell_tiles exercise
```gherkin
Given the exercise type is "spell_tiles"
When the exercise loads
Then audio plays stating the word to spell (e.g. "Spell ship")
And empty letter slots are shown
And a bank of letter tiles is displayed (answer letters + distractors)
When the child taps letters in the correct order to fill the slots
Then the correct-answer feedback is triggered
```

### Scenario 6.5: spell_tiles — wrong letter placement
```gherkin
Given the child is on a "spell_tiles" exercise
When the child taps an incorrect letter for a slot
Then a gentle sound plays
And the letter is not placed in the slot
And the child can try another letter
```

### Scenario 6.6: build_sentence exercise
```gherkin
Given the exercise type is "build_sentence"
When the exercise loads
Then scrambled word tiles are displayed
And an empty sentence area is shown
When the child drags word tiles into the correct order
Then the correct-answer feedback is triggered
```

### Scenario 6.7: match_pairs exercise
```gherkin
Given the exercise type is "match_pairs"
When the exercise loads
Then two columns are displayed (e.g. words and pictures)
When the child taps one item from each column that form a correct pair
Then the pair is connected visually
When all pairs are matched
Then the correct-answer feedback is triggered
```

### Scenario 6.8: count_tap exercise
```gherkin
Given the exercise type is "count_tap"
When the exercise loads
Then a group of objects is displayed
When the child taps each object to count it
Then a running tally is displayed and incremented with each tap
When the child taps the final count matching the correct answer
Then the correct-answer feedback is triggered
```

### Scenario 6.9: number_line exercise
```gherkin
Given the exercise type is "number_line"
When the exercise loads
Then a number line is displayed
When the child drags a marker to the correct position on the line
Then the correct-answer feedback is triggered
```

### Scenario 6.10: sort_bins exercise
```gherkin
Given the exercise type is "sort_bins"
When the exercise loads
Then 2–3 labeled bins are displayed
And draggable items are shown
When the child drags each item into the correct bin
Then the correct-answer feedback is triggered
```

### Scenario 6.11: true_false exercise
```gherkin
Given the exercise type is "true_false"
When the exercise loads
Then an audio statement plays
And two large buttons are shown: checkmark (true) and X (false)
When the child taps the correct button
Then the correct-answer feedback is triggered
```

### Scenario 6.12: listen_and_answer exercise
```gherkin
Given the exercise type is "listen_and_answer"
When the exercise loads
Then a short audio passage (2–3 sentences) plays
After the audio finishes
Then a comprehension question is displayed with answer options
When the child selects the correct answer
Then the correct-answer feedback is triggered
```

---

## Epic 7: Mastery & Leitner Scheduling

### Scenario 7.1: New item starts at box 0
```gherkin
Given an item has never been seen by the child
When the item is first presented in a lesson
Then its Leitner box level is 0
```

### Scenario 7.2: Correct first-try moves item up one box
```gherkin
Given an item is at box level 2
When the child answers it correctly on the first try
Then the item moves to box level 3
And the next review due date is set to 4 days from today
```

### Scenario 7.3: Incorrect answer drops item to box 1
```gherkin
Given an item is at box level 4
When the child answers it incorrectly on the first try
Then the item drops to box level 1
And the next review due date is set to 1 day from today
```

### Scenario 7.4: Leitner box review intervals
```gherkin
Given items exist at each box level
When the system calculates due dates
Then box 1 items are due in 1 day
And box 2 items are due in 2 days
And box 3 items are due in 4 days
And box 4 items are due in 8 days
And box 5 items are due in 16 days
```

### Scenario 7.5: Skill mastery percentage calculation
```gherkin
Given skill "eng.shortvowel.a" has 25 total items
And 20 items are at box level 3 or above
When mastery is calculated
Then the mastery percentage is 80%
```

### Scenario 7.6: Overdue items are prioritized for review
```gherkin
Given the child has items past their due date from completed skills
When a new lesson is composed
Then overdue review items are included in the 30% review allocation
```

---

## Epic 8: Motivation — Coins, Pet & Shop

### Scenario 8.1: Earn coin on first-try correct
```gherkin
Given the child answers an exercise correctly on the first try
When the answer feedback completes
Then the child's coin balance increases by 1
```

### Scenario 8.2: Earn 5 coins for completing a lesson
```gherkin
Given the child completes a lesson
When the Lesson Complete screen is shown
Then 5 bonus coins are added to the balance
```

### Scenario 8.3: Pet displayed on home screen
```gherkin
Given the child has a pet character
When the Home screen is displayed
Then the pet is visible and animated on the home screen
```

### Scenario 8.4: Open the shop
```gherkin
Given the child is on the Home screen
When the child taps the pet or shop button
Then the Pet/Shop screen is displayed
And it shows available items (hats, food, backgrounds) with coin prices
And it shows the child's current coin balance
```

### Scenario 8.5: Buy a shop item
```gherkin
Given the child has 15 coins
And a hat costs 10 coins
When the child taps the hat and confirms purchase
Then 10 coins are deducted from the balance
And the hat is added to the child's inventory
And the pet is shown wearing the hat
```

### Scenario 8.6: Cannot buy item without enough coins
```gherkin
Given the child has 5 coins
And a background scene costs 20 coins
When the child taps the background scene
Then the purchase is blocked
And a message indicates more coins are needed
```

---

## Epic 9: Motivation — Weekly Goal & Trophies

### Scenario 9.1: Weekly goal increments after a lesson
```gherkin
Given the child has practiced on 2 days this week
And the weekly goal is 4 days
When the child completes a lesson on a new day
Then the weekly goal ring updates to "3 of 4 days"
```

### Scenario 9.2: Weekly goal achieved
```gherkin
Given the child has practiced on 3 days this week
And the weekly goal is 4 days
When the child completes a lesson on a 4th day
Then the weekly goal ring shows as complete
And a celebration animation plays
```

### Scenario 9.3: Trophy awarded on unit completion
```gherkin
Given all skills in English unit "E1. Letters & sounds" are at 80% mastery or above
When the last skill reaches the threshold
Then a trophy badge is awarded for unit E1
And the trophy appears on the Home screen trophy shelf
```

### Scenario 9.4: Trophy shelf displays earned badges
```gherkin
Given the child has earned 2 unit trophies
When the Home screen is displayed
Then 2 badges are shown on the trophy shelf area
```

---

## Epic 10: Optional Speed Game

### Scenario 10.1: Speed game unlocked by parent
```gherkin
Given the parent has enabled the speed game in Parent Mode settings
When the child navigates to the speed game option
Then the speed game is accessible
```

### Scenario 10.2: Speed game is hidden when disabled
```gherkin
Given the parent has disabled the speed game in Parent Mode settings
When the child views the Home screen
Then no speed game option is visible
```

### Scenario 10.3: Speed game uses only mastered items
```gherkin
Given the speed game is enabled
When the child starts a speed game
Then only items the child has already mastered (box >= 3) are used
And the game lasts 60 seconds
```

### Scenario 10.4: Speed game does not gate progress
```gherkin
Given the child has never played the speed game
When the child progresses through the skill path
Then no skill unlock requires speed game participation
```

---

## Epic 11: Parent Mode — Access Gate

### Scenario 11.1: Parent gate blocks child access
```gherkin
Given the child is on the Home screen
When the child taps the Parent Mode icon
Then a gate challenge is displayed (e.g. "What is 7 x 8?" or hold button for 3 seconds)
And the child cannot proceed without passing the gate
```

### Scenario 11.2: Parent passes the gate
```gherkin
Given the parent gate is displayed
When the parent correctly answers the math challenge (or holds the button for 3 seconds)
Then the Parent Mode dashboard is displayed
```

---

## Epic 12: Parent Mode — Progress Dashboard

### Scenario 12.1: View mastery per skill
```gherkin
Given the parent is in Parent Mode
When the dashboard loads
Then mastery percentage is shown for each skill
And skills are grouped by unit and subject
```

### Scenario 12.2: View time spent per day
```gherkin
Given the parent is in Parent Mode
When the dashboard loads
Then a daily time-spent chart is displayed
```

### Scenario 12.3: View first-try accuracy trend
```gherkin
Given the parent is in Parent Mode
When the dashboard loads
Then a first-try accuracy trend chart is displayed over recent sessions
```

### Scenario 12.4: View trouble spots
```gherkin
Given the parent is in Parent Mode
When the parent navigates to "Trouble Spots"
Then the 10 items with the most misses are listed
And each item shows the miss count and the skill it belongs to
```

---

## Epic 13: Parent Mode — Content Controls & Settings

### Scenario 13.1: Enable or disable units
```gherkin
Given the parent is in Parent Mode content controls
When the parent disables unit "E6. Word meaning"
Then all skills in E6 are hidden from the child's Path screen
And the child cannot access those skills
```

### Scenario 13.2: Force unlock a skill
```gherkin
Given the parent is in Parent Mode content controls
When the parent force-unlocks skill "eng.longvowels.silent_e"
Then that skill becomes available on the child's Path screen
Regardless of prerequisite mastery levels
```

### Scenario 13.3: Reset a skill
```gherkin
Given the parent is in Parent Mode content controls
When the parent resets skill "eng.shortvowel.a"
Then all item progress for that skill is set back to box 0
And the skill node reverts to its initial (non-gold) state
```

### Scenario 13.4: Set daily goal
```gherkin
Given the parent is in Parent Mode session settings
When the parent sets the daily goal to 3 lessons
Then the child's daily goal is updated to 3 lessons
And this is persisted in Firebase
```

### Scenario 13.5: Set weekly goal
```gherkin
Given the parent is in Parent Mode session settings
When the parent sets the weekly goal to 5 days
Then the weekly goal ring on the Home screen updates to "X of 5 days"
```

### Scenario 13.6: Set session time cap
```gherkin
Given the parent is in Parent Mode session settings
When the parent sets a session time cap of 15 minutes
And the child has been in a session for 15 minutes
Then the app suggests the child take a break
And displays a friendly wind-down message
```

### Scenario 13.7: Adjust sound and music volume
```gherkin
Given the parent is in Parent Mode session settings
When the parent adjusts the sound volume slider
Then the app's audio playback volume is updated accordingly
```

### Scenario 13.8: Toggle speed game availability
```gherkin
Given the parent is in Parent Mode session settings
When the parent toggles the speed game to "available"
Then the speed game option appears on the child's Home screen
```

---

## Epic 14: Parent Mode — Data Management

### Scenario 14.1: Export progress to JSON
```gherkin
Given the parent is in Parent Mode
When the parent taps "Export Progress"
Then all progress data is exported as a JSON file
And the file is saved to the device or shared via system share sheet
```

### Scenario 14.2: Wipe all data
```gherkin
Given the parent is in Parent Mode
When the parent taps "Wipe All Data"
Then a confirmation dialog is displayed
When the parent confirms
Then all child progress data is deleted from Firebase
And the app returns to a fresh state as if newly installed
```

---

## Epic 15: UI/UX — Child-Friendly Design

### Scenario 15.1: All prompts have audio
```gherkin
Given any exercise or screen in the child-facing UI
When the screen loads
Then spoken audio plays automatically
And a persistent replay button is available
```

### Scenario 15.2: Icon-based navigation
```gherkin
Given the child is on any screen
When the child needs to navigate
Then all navigation elements use recognizable pictures/icons
And no menu is text-only
```

### Scenario 15.3: Minimum tap target size
```gherkin
Given any interactive element in the child-facing UI
When the element is rendered
Then its tap target is at least 64x64 logical pixels
And spacing between targets is generous
```

### Scenario 15.4: No keyboard input
```gherkin
Given any exercise in the app
When input is required
Then the child uses tap or drag interactions only
And no keyboard or text field is ever presented
```

### Scenario 15.5: No time pressure in core lessons
```gherkin
Given the child is in a core lesson exercise
When the exercise is displayed
Then no countdown timer or time limit is shown
And the child can take as long as needed to answer
```

### Scenario 15.6: Colorblind-safe feedback
```gherkin
Given the child answers an exercise
When feedback is displayed
Then correct/incorrect is not signaled by color alone
And sound + symbols (checkmark / X) are also used
```

### Scenario 15.7: Feedback within 200ms
```gherkin
Given the child taps an answer
When the answer is evaluated
Then visual and audio feedback begins within 200 milliseconds
```

---

## Epic 16: Backend API (Spring Boot) & Firebase

### Scenario 16.1: Child profile creation
```gherkin
Given the app is launched for the first time
When the app initializes
Then a child profile is created in Firebase via the Spring Boot API
And the profile contains default settings and zero progress
```

### Scenario 16.2: Load curriculum content
```gherkin
Given the child selects a subject
When the Path screen requests skill data
Then the Spring Boot API returns the unit/skill/item hierarchy from stored JSON content
And the response includes prerequisites and item IDs for each skill
```

### Scenario 16.3: Load lesson exercises
```gherkin
Given the child starts a lesson for a skill
When the Lesson screen requests exercises
Then the Spring Boot API composes and returns 8–12 exercises
And the composition follows the 50/30/20 ratio (new/review/mistake)
And each exercise includes type, prompt, answer, distractors, hint, and assets
```

### Scenario 16.4: Submit exercise result
```gherkin
Given the child completes an exercise
When the result is submitted to the backend
Then the Spring Boot API updates the item's Leitner box level in Firebase
And updates the due date based on the result
And updates the coin balance if it was a first-try correct
And adds the item to the mistake queue if answered incorrectly
```

### Scenario 16.5: Submit lesson completion
```gherkin
Given the child finishes a lesson
When lesson completion is submitted to the backend
Then the Spring Boot API records the lesson completion in Firebase
And awards 5 bonus coins
And updates the weekly goal progress
And updates skill mastery percentages
And evaluates whether any new skills should be unlocked
```

### Scenario 16.6: Fetch progress for parent dashboard
```gherkin
Given the parent opens the Parent Mode dashboard
When the dashboard requests progress data
Then the Spring Boot API returns mastery per skill, time spent per day, first-try accuracy trends, and trouble spots from Firebase
```

### Scenario 16.7: Update parent settings
```gherkin
Given the parent changes a setting (e.g. daily goal, weekly goal, volume)
When the setting is saved via the API
Then the Spring Boot API persists the updated setting in Firebase
And subsequent child sessions reflect the new setting
```

### Scenario 16.8: Content stored as version-controlled JSON
```gherkin
Given curriculum content (units, skills, items) is stored as JSON files
When the Spring Boot API serves content requests
Then the content is loaded from these JSON files
And content can be updated without modifying application code
```

---

## Epic 17: Offline & Sync

### Scenario 17.1: App works with intermittent connectivity
```gherkin
Given the child is in the middle of a lesson
And the device temporarily loses internet connection
When the child continues answering exercises
Then the lesson continues without interruption
And results are queued locally
```

### Scenario 17.2: Sync queued results when back online
```gherkin
Given exercise results were queued while offline
When the device reconnects to the internet
Then queued results are synced to Firebase via the Spring Boot API
And progress, coins, and mastery are updated accordingly
```

---

## Epic 18: Accessibility & Safety

### Scenario 18.1: All audio has text equivalents
```gherkin
Given any screen with audio playback
When audio plays
Then the equivalent text is displayed on screen
```

### Scenario 18.2: All text has audio
```gherkin
Given any screen with displayed text in the child UI
When the text is shown
Then corresponding audio is available (auto-play or replay button)
```

### Scenario 18.3: No external links in child UI
```gherkin
Given the child is on any child-facing screen
When the child interacts with the UI
Then no external links or browser navigation is possible
```

### Scenario 18.4: Larger font option
```gherkin
Given the parent enables "larger font" in settings
When the child views any screen
Then text is rendered in a larger, wider-spaced font
```

---

## Epic 19: Admin Web Portal — Authentication & Layout

> The Admin Portal is a separate web app served by Spring Boot, used on a laptop/desktop by the parent-developer to author and manage curriculum content. The Flutter child app only *consumes* this content.

### Scenario 19.1: Admin login
```gherkin
Given the admin portal is running
When the admin navigates to the portal URL
Then a login screen is displayed
When valid credentials are entered
Then the admin dashboard is displayed
```

### Scenario 19.2: Admin portal navigation
```gherkin
Given the admin is logged in
When the dashboard loads
Then a sidebar navigation is displayed with sections:
  | Section              |
  | Dashboard            |
  | Units and Skills     |
  | Items (Exercises)    |
  | Audio Assets         |
  | Image Assets         |
  | Import and Export    |
  | Child App Settings   |
```

### Scenario 19.3: Admin dashboard overview
```gherkin
Given the admin is logged in
When the dashboard section is selected
Then an overview is shown with:
  | Metric                              |
  | Total units, skills, and items      |
  | Items per exercise type breakdown   |
  | Content coverage per unit (percent) |
  | Last content modification date      |
```

---

## Epic 20: Admin Portal — Unit and Skill Management

### Scenario 20.1: Create a new unit
```gherkin
Given the admin is on the Units and Skills page
When the admin clicks Add Unit
And fills in unit code, subject, and title
And saves
Then the unit is persisted in Firebase
And it appears in the units list
```

### Scenario 20.2: Create a new skill within a unit
```gherkin
Given the admin is on the Units and Skills page
When the admin selects a unit and clicks Add Skill
And fills in skill ID, title, icon name, and selects prerequisites from a dropdown
And saves
Then the skill is persisted in Firebase under the selected unit
And it appears in the skill path for the child app
```

### Scenario 20.3: Edit an existing skill
```gherkin
Given the admin is on the Units and Skills page
When the admin clicks on a skill and modifies its title, icon, or prerequisites
And saves
Then the changes are persisted in Firebase
And the child app reflects the changes on next content load
```

### Scenario 20.4: Delete a skill
```gherkin
Given the admin is on the Units and Skills page
When the admin deletes a skill
Then a confirmation dialog warns about associated items
When confirmed
Then the skill and all its associated items are removed from Firebase
And any child progress on those items is also removed
```

### Scenario 20.5: Reorder skills within a unit
```gherkin
Given the admin is on the Units and Skills page
When the admin drags skills to reorder them within a unit
And saves
Then the new order is persisted
And the child app displays the skill path in the updated order
```

---

## Epic 21: Admin Portal — Item (Exercise) Management

### Scenario 21.1: Browse and filter items
```gherkin
Given the admin is on the Items page
When the page loads
Then all items are listed in a table with columns: ID, Skill, Type, Prompt, Difficulty
And the admin can filter by subject, unit, skill, and exercise type
And the admin can search by item ID or prompt text
```

### Scenario 21.2: Create a new item via form
```gherkin
Given the admin is on the Items page
When the admin clicks Add Item
And selects the target skill and exercise type
And fills in the type-specific fields:
  | Field         | Description                              |
  | Prompt text   | The question or instruction text          |
  | Prompt audio  | Upload or select audio file               |
  | Answer        | The correct answer (varies by type)       |
  | Distractors   | Wrong answer options                      |
  | Hint config   | Hint audio and remove-distractor count    |
  | Assets        | Associated image files                    |
  | Difficulty    | 1 to 5 scale                              |
And saves
Then the item is persisted in Firebase
And it becomes available in the child app content pool
```

### Scenario 21.3: Edit an existing item
```gherkin
Given the admin is on the Items page
When the admin clicks on an item to edit it
And modifies any field (prompt, answer, distractors, hint, assets)
And saves
Then the changes are persisted in Firebase
And the child app uses the updated content on next encounter
```

### Scenario 21.4: Delete an item
```gherkin
Given the admin is editing an item
When the admin clicks Delete and confirms
Then the item is removed from Firebase
And any child progress for that item is removed
And the item is removed from the skill itemIds list
```

### Scenario 21.5: Preview an exercise as the child would see it
```gherkin
Given the admin is viewing or editing an item
When the admin clicks Preview
Then a simulated exercise view is displayed (matching the Flutter child UI)
And the admin can interact with it as a child would
And correct and incorrect feedback is simulated
```

### Scenario 21.6: Bulk create items for a skill
```gherkin
Given the admin is on the Items page
When the admin selects a skill and clicks Bulk Add
And enters multiple items in a structured table view
And saves all
Then all items are persisted in Firebase
And the skill item count is updated
```

---

## Epic 22: Admin Portal — Asset Management

### Scenario 22.1: Upload audio files
```gherkin
Given the admin is on the Audio Assets page
When the admin uploads one or more MP3 files
And assigns each to an item or marks as unassigned
Then the audio files are stored in Firebase Storage
And file references are linked to the corresponding items
```

### Scenario 22.2: Upload image files
```gherkin
Given the admin is on the Image Assets page
When the admin uploads one or more image files (PNG or SVG)
And assigns tags or links them to items
Then the images are stored in Firebase Storage
And file references are linked to the corresponding items
```

### Scenario 22.3: Browse and search assets
```gherkin
Given the admin is on the Audio or Image Assets page
When the page loads
Then all assets are displayed with thumbnails or waveform previews
And the admin can search by filename, tag, or linked item
```

### Scenario 22.4: Delete an asset with linked items
```gherkin
Given the admin is on an asset page
When the admin deletes an asset that is linked to one or more items
Then a warning shows which items reference this asset
When confirmed
Then the asset is removed from Firebase Storage
And linked items show a missing asset warning
```

### Scenario 22.5: Content health report
```gherkin
Given the admin is on the Dashboard
When the Content Health check runs
Then a report lists:
  | Issue                             |
  | Items with missing audio          |
  | Items with missing images         |
  | Items with no distractors         |
  | Skills with fewer than 5 items    |
```

---

## Epic 23: Admin Portal — Import and Export

### Scenario 23.1: Bulk import items from JSON
```gherkin
Given the admin is on the Import and Export page
When the admin uploads a JSON file containing items
And the system validates the JSON structure
And all items are valid
Then the items are imported into Firebase
And a summary is shown (e.g. "Imported 47 items into skill eng.shortvowel.a")
```

### Scenario 23.2: Import validation errors
```gherkin
Given the admin uploads a JSON file for import
When the JSON contains invalid items (missing fields, unknown types)
Then the system displays a list of errors with line or item identifiers
And no items are imported until errors are resolved
```

### Scenario 23.3: Export all content as JSON
```gherkin
Given the admin is on the Import and Export page
When the admin clicks Export All Content
Then a JSON file is downloaded containing all units, skills, and items
And the file format matches the import schema for round-trip compatibility
```

### Scenario 23.4: Export a single unit or skill
```gherkin
Given the admin is on the Import and Export page
When the admin selects a specific unit or skill and clicks Export
Then only that unit or skill and its items are exported as JSON
```

---

## Epic 24: Admin Portal — Child App Settings and Content Push

### Scenario 24.1: Configure global app defaults
```gherkin
Given the admin is on the Child App Settings page
When the admin modifies settings:
  | Setting                | Example Value  |
  | Default daily goal     | 2 lessons      |
  | Default weekly goal    | 4 days         |
  | Session time cap       | 15 minutes     |
  | Default sound volume   | 80 percent     |
  | Speed game enabled     | false          |
  | Larger font enabled    | false          |
And saves
Then settings are persisted in Firebase
And the child app applies these as defaults on next launch
```

### Scenario 24.2: Force content refresh on child app
```gherkin
Given the admin has made content changes
When the admin clicks Push Content Update
Then a version flag is updated in Firebase
And the child app detects the new version on next launch or resume
And the child app fetches fresh content from the API
```

---

## Epic 25: Admin Portal — REST API Endpoints

> These scenarios define the Spring Boot endpoints powering the admin portal.

### Scenario 25.1: Unit CRUD endpoints
```gherkin
Given the admin portal backend is running
When the admin performs unit operations via REST API:
  | Method | Endpoint           | Action        |
  | GET    | /api/admin/units   | List all units|
  | POST   | /api/admin/units   | Create unit   |
  | PUT    | /api/admin/units/:id | Update unit |
  | DELETE | /api/admin/units/:id | Delete unit |
Then each operation is persisted in Firebase
And appropriate HTTP status codes are returned
```

### Scenario 25.2: Skill CRUD endpoints
```gherkin
Given the admin portal backend is running
When the admin performs skill operations via REST API:
  | Method | Endpoint                      | Action         |
  | GET    | /api/admin/skills             | List all skills|
  | GET    | /api/admin/skills?unit=E2     | Filter by unit |
  | POST   | /api/admin/skills             | Create skill   |
  | PUT    | /api/admin/skills/:id         | Update skill   |
  | DELETE | /api/admin/skills/:id         | Delete skill   |
Then each operation is persisted in Firebase
```

### Scenario 25.3: Item CRUD endpoints
```gherkin
Given the admin portal backend is running
When the admin performs item operations via REST API:
  | Method | Endpoint                      | Action         |
  | GET    | /api/admin/items              | List with filters |
  | POST   | /api/admin/items              | Create item    |
  | PUT    | /api/admin/items/:id          | Update item    |
  | DELETE | /api/admin/items/:id          | Delete item    |
  | POST   | /api/admin/items/bulk         | Bulk create    |
Then each operation is persisted in Firebase
```

### Scenario 25.4: Asset upload endpoints
```gherkin
Given the admin portal backend is running
When the admin uploads assets via REST API:
  | Method | Endpoint                      | Action              |
  | POST   | /api/admin/assets/audio       | Upload audio file(s)|
  | POST   | /api/admin/assets/images      | Upload image file(s)|
  | GET    | /api/admin/assets             | List all assets     |
  | DELETE | /api/admin/assets/:id         | Delete asset        |
Then files are stored in Firebase Storage
And metadata is stored in Firestore
```

### Scenario 25.5: Import and export endpoints
```gherkin
Given the admin portal backend is running
When the admin uses import/export via REST API:
  | Method | Endpoint                      | Action                  |
  | POST   | /api/admin/import/json        | Import items from JSON  |
  | GET    | /api/admin/export/all         | Export all content      |
  | GET    | /api/admin/export/unit/:id    | Export single unit      |
  | GET    | /api/admin/export/skill/:id   | Export single skill     |
Then import validates content before persisting
And export returns valid JSON matching the import schema
```

### Scenario 25.6: Content versioning endpoint
```gherkin
Given the admin portal backend is running
When the admin triggers a content push
Then the endpoint PUT /api/admin/content-version increments the version in Firebase
And the child app can GET /api/content-version to check for updates
```

---

## Summary

| Epic | Feature Area | Scenarios |
|------|-------------|-----------|
| 1 | Home Screen | 6 |
| 2 | Skill Path Navigation | 7 |
| 3 | Lesson Flow | 10 |
| 4 | Correct Answer Handling | 3 |
| 5 | Incorrect Answer and No-Fail Loop | 6 |
| 6 | Exercise Types | 12 |
| 7 | Mastery and Leitner Scheduling | 6 |
| 8 | Coins, Pet and Shop | 6 |
| 9 | Weekly Goal and Trophies | 4 |
| 10 | Optional Speed Game | 4 |
| 11 | Parent Mode — Access Gate | 2 |
| 12 | Parent Mode — Dashboard | 4 |
| 13 | Parent Mode — Controls and Settings | 8 |
| 14 | Parent Mode — Data Management | 2 |
| 15 | Child-Friendly UI/UX | 7 |
| 16 | Backend API and Firebase | 8 |
| 17 | Offline and Sync | 2 |
| 18 | Accessibility and Safety | 4 |
| 19 | Admin Portal — Auth and Layout | 3 |
| 20 | Admin Portal — Unit and Skill Management | 5 |
| 21 | Admin Portal — Item Management | 6 |
| 22 | Admin Portal — Asset Management | 5 |
| 23 | Admin Portal — Import and Export | 4 |
| 24 | Admin Portal — Settings and Content Push | 2 |
| 25 | Admin Portal — REST API Endpoints | 6 |
| **Total** | | **136** |
