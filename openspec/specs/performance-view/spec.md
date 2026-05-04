## ADDED Requirements

### Requirement: Set Preview shows set details and a Start button
The Set Preview screen SHALL display the set name, formatted duration, bit count, and a numbered list of all bit prompts. A Start button enters Performance mode.

#### Scenario: Preview displays set content
- **WHEN** the user navigates to a set's preview
- **THEN** the screen shows the set name, duration, number of bits, and all prompts in order

#### Scenario: Start button enters performance mode
- **WHEN** the user taps Start
- **THEN** the Performance View opens, the timer begins immediately, and the first bit is shown

### Requirement: Performance View displays a countdown timer
The Performance View SHALL show a large countdown timer at the top of the screen counting down from the set's total duration.

#### Scenario: Timer counts down
- **WHEN** the Performance View is active
- **THEN** the timer decrements by one second each second from the set's total duration

#### Scenario: Timer hits zero
- **WHEN** the elapsed time reaches the set's total duration
- **THEN** the timer display turns red and begins counting upward (overtime elapsed time)

### Requirement: Performance View displays a progress indicator
The Performance View SHALL show a segmented progress bar below the timer, with one segment per bit, indicating the current position in the set.

#### Scenario: Progress reflects current bit
- **WHEN** the user is on bit N of M
- **THEN** segments 1 through N-1 are filled, segment N is highlighted as current, segments N+1 through M are unfilled

### Requirement: User can advance to the next bit
The Performance View SHALL advance to the next bit when the user taps the bottom half of the screen.

#### Scenario: Tap advances slide
- **WHEN** the user taps the bottom half of the screen
- **THEN** the next bit prompt is displayed and the progress indicator updates

#### Scenario: Tap on last bit
- **WHEN** the user taps on the last bit
- **THEN** no further advance occurs (the last bit remains displayed)

### Requirement: User can go back to the previous bit
The Performance View SHALL include a back button at the bottom-left to return to the previous bit.

#### Scenario: Back button returns to previous bit
- **WHEN** the user taps the back button
- **THEN** the previous bit prompt is displayed and the progress indicator updates

#### Scenario: Back button on first bit
- **WHEN** the user is on the first bit and taps the back button
- **THEN** the button is disabled or hidden and no navigation occurs

### Requirement: Screen stays awake during performance
The Performance View SHALL prevent the device screen from sleeping while it is displayed.

#### Scenario: Screen wake lock active
- **WHEN** the Performance View is on screen
- **THEN** the device idle timer is disabled and the screen does not auto-lock

#### Scenario: Screen wake lock released
- **WHEN** the user leaves the Performance View
- **THEN** the device idle timer is re-enabled

### Requirement: User can exit performance mode
The Performance View SHALL allow the user to exit and return to the Set Preview screen.

#### Scenario: Exit mid-set shows confirmation
- **WHEN** the user attempts to dismiss the Performance View before the timer has ended
- **THEN** a confirmation prompt is shown before navigating back to Set Preview

#### Scenario: Exit after set ends
- **WHEN** the timer has expired and the user dismisses the Performance View
- **THEN** the app navigates directly back to Set Preview without a confirmation prompt
