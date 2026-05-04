## MODIFIED Requirements

### Requirement: Sets are persisted across app launches
The app SHALL save all sets to local storage and restore them on next launch.

#### Scenario: Set survives app restart
- **WHEN** the user saves a set and relaunches the app
- **THEN** the set appears in the Set List with its original name, duration, and bit content

#### Scenario: Timing data survives app restart
- **WHEN** the user performs a set and relaunches the app
- **THEN** the set's recorded bit timings are preserved and visible in Set Preview

#### Scenario: Sets without timing data decode correctly
- **WHEN** the app loads a sets.json that contains sets without timing data
- **THEN** those sets load successfully with no timing information shown
