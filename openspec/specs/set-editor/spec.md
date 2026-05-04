## ADDED Requirements

### Requirement: User can enter a set name
The Set Editor SHALL include a text field for the set's name.

#### Scenario: Name field is empty on save
- **WHEN** the user attempts to save a set with an empty name field
- **THEN** the app displays an inline validation error and blocks saving

### Requirement: User can enter a set duration
The Set Editor SHALL include a field for the total set duration in MM:SS format.

#### Scenario: Valid duration entered
- **WHEN** the user enters a valid MM:SS string (e.g. "10:00")
- **THEN** the duration is accepted and stored as a total number of seconds

#### Scenario: Invalid duration entered
- **WHEN** the user enters an invalid string (e.g. "abc", "99:99", empty)
- **THEN** the app displays an inline validation error and blocks saving

### Requirement: User can enter bit prompts as a markdown bullet list
The Set Editor SHALL include a multiline text area where each bullet point (`- `, `* `, or `•`) on its own line becomes one bit prompt.

#### Scenario: Markdown list parsed into bits
- **WHEN** the user enters a markdown bullet list and saves
- **THEN** each non-empty bullet line is stored as a separate bit prompt

#### Scenario: Empty lines and non-bullet lines ignored
- **WHEN** the user's input contains blank lines or lines without a bullet prefix
- **THEN** those lines are ignored during parsing and do not produce bit prompts

#### Scenario: No bits entered on save
- **WHEN** the user attempts to save a set with no valid bullet points
- **THEN** the app displays an inline validation error and blocks saving

### Requirement: User can save a set
The Set Editor SHALL include a Save button that validates and persists the set.

#### Scenario: All fields valid
- **WHEN** the user taps Save with a valid name, duration, and at least one bit
- **THEN** the set is saved, the editor closes, and the set appears in the Set List

### Requirement: User can edit an existing set
The Set Preview screen SHALL include an Edit button that opens the Set Editor pre-populated with the set's current data.

#### Scenario: Edit button opens pre-populated editor
- **WHEN** the user taps Edit on the Set Preview screen
- **THEN** the Set Editor opens with the set's name, duration, and raw markdown content pre-filled

#### Scenario: Saving edits updates the set
- **WHEN** the user modifies fields and taps Save
- **THEN** the set is updated in storage and the Preview reflects the new content
