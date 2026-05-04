## ADDED Requirements

### Requirement: User can view all saved sets
The app SHALL display a list of all saved comedy sets on launch, showing each set's name and formatted duration.

#### Scenario: App opens with saved sets
- **WHEN** the user opens the app with one or more saved sets
- **THEN** the Set List screen displays each set by name with its duration (e.g. "10:00")

#### Scenario: App opens with no sets
- **WHEN** the user opens the app with no saved sets
- **THEN** the Set List screen displays an empty state prompt to create a new set

### Requirement: User can create a new set
The app SHALL provide a button to create a new set, opening the Set Editor.

#### Scenario: Tap new set button
- **WHEN** the user taps the "New Set" button on the Set List screen
- **THEN** the Set Editor opens as a sheet with empty fields

### Requirement: User can navigate to a set's preview
The app SHALL navigate to the Set Preview screen when a set is tapped in the list.

#### Scenario: Tap a set in the list
- **WHEN** the user taps a set in the Set List
- **THEN** the app navigates to the Set Preview screen for that set

### Requirement: User can delete a set
The app SHALL allow sets to be deleted from the Set List via swipe-to-delete.

#### Scenario: Swipe to delete a set
- **WHEN** the user swipes left on a set row
- **THEN** a delete button is revealed; tapping it removes the set from the list and from storage

### Requirement: Sets are persisted across app launches
The app SHALL save all sets to local storage and restore them on next launch.

#### Scenario: Set survives app restart
- **WHEN** the user saves a set and relaunches the app
- **THEN** the set appears in the Set List with its original name, duration, and bit content
