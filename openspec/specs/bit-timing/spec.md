## ADDED Requirements

### Requirement: App records dwell time per bit during a performance
The app SHALL accumulate total time spent on each bit index during a performance run, including time revisited via the back button, and persist these timings to the set after the performance ends.

#### Scenario: Timings saved after completing a set
- **WHEN** the user reaches the FIN page
- **THEN** the total dwell time for each bit is saved to `ComedySet.lastRunBitDurations`

#### Scenario: Timings saved after early dismissal
- **WHEN** the user exits the performance before reaching FIN
- **THEN** dwell times accumulated so far are saved; bits not reached have a dwell time of zero

#### Scenario: Back navigation accumulates time on revisited bit
- **WHEN** the user taps back to a previously visited bit and spends additional time on it
- **THEN** that additional time is added to the bit's total dwell time

#### Scenario: Subsequent run overwrites previous timings
- **WHEN** the user performs the same set a second time
- **THEN** the new dwell times replace the previous `lastRunBitDurations`

### Requirement: Set Preview displays per-bit timings after a performance
The Set Preview screen SHALL display each bit's recorded dwell time alongside its prompt when timing data is available.

#### Scenario: Timings shown after a run
- **WHEN** the user views a set that has been performed at least once
- **THEN** each bit prompt in the list shows its recorded dwell time formatted as `M:SS`

#### Scenario: No timings before first run
- **WHEN** the user views a set that has never been performed
- **THEN** no timing information is shown in the bit list
