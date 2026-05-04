## ADDED Requirements

### Requirement: Performance View has a FIN page as its terminal state
The Performance View SHALL display a FIN page after the last bit prompt. Tapping the last bit prompt advances to FIN. The FIN page cannot be advanced past.

#### Scenario: Advancing from last bit shows FIN
- **WHEN** the user taps the prompt area while on the last bit
- **THEN** the FIN page is displayed with the text "FIN"

#### Scenario: FIN page cannot be advanced
- **WHEN** the user taps the prompt area on the FIN page
- **THEN** nothing happens and FIN remains displayed

#### Scenario: Back button on FIN returns to last bit
- **WHEN** the user taps the back button on the FIN page
- **THEN** the last bit prompt is displayed

### Requirement: Timer freezes when FIN is reached
The Performance View SHALL stop updating the timer display when the FIN page is reached, freezing it at the value shown at the moment FIN was entered.

#### Scenario: Timer freezes on FIN
- **WHEN** the user reaches the FIN page
- **THEN** the timer display stops changing and holds its current value

#### Scenario: Timer resumes if user navigates back from FIN
- **WHEN** the user taps back from the FIN page to the last bit
- **THEN** the timer resumes counting from where it was frozen

### Requirement: Progress bar is fully filled on the FIN page
The segmented progress bar SHALL show all segments filled when the FIN page is displayed.

#### Scenario: All segments filled on FIN
- **WHEN** the FIN page is displayed
- **THEN** every segment in the progress bar is shown in the filled state

## MODIFIED Requirements

### Requirement: User can exit performance mode
The Performance View SHALL allow the user to exit and return to the Set Preview screen.

#### Scenario: Exit mid-set shows confirmation
- **WHEN** the user attempts to dismiss the Performance View before the timer has ended and FIN has not been reached
- **THEN** a confirmation prompt is shown before navigating back to Set Preview

#### Scenario: Exit after set ends
- **WHEN** the timer has expired and the user dismisses the Performance View
- **THEN** the app navigates directly back to Set Preview without a confirmation prompt

#### Scenario: Exit from FIN page
- **WHEN** the user dismisses the Performance View from the FIN page
- **THEN** the app navigates directly back to Set Preview without a confirmation prompt
