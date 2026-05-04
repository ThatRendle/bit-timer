## MODIFIED Requirements

### Requirement: User can save a set
The Set Editor SHALL include a Save button that validates and persists the set.

#### Scenario: All fields valid
- **WHEN** the user taps Save with a valid name, duration, and at least one bit
- **THEN** the set is saved, the editor closes, and the set appears in the Set List

#### Scenario: Saving with changed bit count clears timing data
- **WHEN** the user edits a set such that the number of bits changes and taps Save
- **THEN** any previously recorded bit timings are cleared

#### Scenario: Saving without changing bit count preserves timing data
- **WHEN** the user edits a set's name or duration without changing the bits and taps Save
- **THEN** previously recorded bit timings are retained
