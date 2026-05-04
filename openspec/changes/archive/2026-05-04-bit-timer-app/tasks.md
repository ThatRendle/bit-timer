## 1. Data Model & Persistence

- [x] 1.1 Define `ComedySet` struct (id, name, durationSeconds, markdownContent) with `Codable` and `Identifiable`
- [x] 1.2 Add `bits: [String]` computed property that parses `markdownContent` bullet lines
- [x] 1.3 Add `String` extension `parseBulletLines()` stripping `- `, `* `, `•` prefixes
- [x] 1.4 Create `SetStore` observable class with `sets: [ComedySet]` array
- [x] 1.5 Implement `load()` — read and decode `sets.json` from Documents directory on init
- [x] 1.6 Implement `save()` — encode and write `sets.json` to Documents directory
- [x] 1.7 Wire `SetStore` into app root via `.environment(store)`

## 2. Set List Screen

- [x] 2.1 Replace `ContentView` with `SetListView` showing a `List` of sets (name + formatted duration)
- [x] 2.2 Add empty-state view when `store.sets` is empty
- [x] 2.3 Add "New Set" toolbar button that opens `SetEditorView` as a sheet
- [x] 2.4 Implement swipe-to-delete on list rows (removes from store and saves)
- [x] 2.5 Add `navigationDestination(for: ComedySet.self)` to navigate to `SetPreviewView`

## 3. Set Editor

- [x] 3.1 Create `SetEditorView` with name `TextField`, duration `TextField`, and multiline `TextEditor` for markdown
- [x] 3.2 Pre-populate fields when editing an existing set
- [x] 3.3 Validate name is non-empty on save attempt (show inline error if not)
- [x] 3.4 Validate duration parses as valid MM:SS on save attempt (show inline error if not)
- [x] 3.5 Validate at least one bullet point exists on save attempt (show inline error if not)
- [x] 3.6 On successful save: add or update set in store, save to disk, dismiss sheet

## 4. Set Preview Screen

- [x] 4.1 Create `SetPreviewView` displaying set name, formatted duration, and bit count
- [x] 4.2 Add numbered list of all bit prompts (read-only)
- [x] 4.3 Add "Edit" toolbar button that opens `SetEditorView` pre-populated with the set
- [x] 4.4 Add "Start" button that navigates to `PerformanceView`

## 5. Performance View — Layout

- [x] 5.1 Create `PerformanceView` with top/middle/bottom layout regions
- [x] 5.2 Build timer display: large monospaced font, white text, shows `MM:SS` remaining
- [x] 5.3 Build segmented progress bar: `HStack` of `RoundedRectangle` segments, one per bit
- [x] 5.4 Build bit prompt display: large centered text filling the bottom region
- [x] 5.5 Add back button (bottom-left, disabled on first bit)

## 6. Performance View — Timer Logic

- [x] 6.1 Store `startDate: Date` on appear; use `Timer.publish(every: 1)` to drive updates
- [x] 6.2 Compute `elapsed` as `Date.now - startDate` each tick; derive `remaining = durationSeconds - elapsed`
- [x] 6.3 Display `remaining` when ≥ 0; display overtime (`abs(remaining)`) in red when < 0
- [x] 6.4 Cancel the timer publisher on disappear

## 7. Performance View — Navigation

- [x] 7.1 Implement `currentIndex` state; tap on bottom region increments it (clamped to last bit)
- [x] 7.2 Back button decrements `currentIndex` (clamped to 0, hidden/disabled at 0)
- [x] 7.3 Add dismiss gesture/button; show confirmation alert if `remaining > 0`
- [x] 7.4 On confirm (or if overtime), navigate back to `SetPreviewView`

## 8. Screen Wake Lock

- [x] 8.1 Set `UIApplication.shared.isIdleTimerDisabled = true` in `PerformanceView.onAppear`
- [x] 8.2 Set `UIApplication.shared.isIdleTimerDisabled = false` in `PerformanceView.onDisappear`

## 9. Polish

- [x] 9.1 Lock app to portrait orientation in project settings
- [x] 9.2 Format duration display as `MM:SS` everywhere (list, preview, timer)
- [x] 9.3 Verify dark-mode appearance looks good (high contrast on stage)
- [x] 9.4 Verify all text scales reasonably at larger Dynamic Type sizes
<!-- 9.3 and 9.4 require visual inspection on simulator/device -->

## 10. Tests

- [x] 10.1 Extract `parseDuration` from `SetEditorView` into `String.parseDurationToSeconds()` in `ComedySet.swift` so it is testable
- [x] 10.2 Unit tests for `String.parseBulletLines()` — all three prefixes, mixed, empty lines, non-bullet lines, whitespace stripping, empty string, bullet with no text (10 cases, Swift Testing)
- [x] 10.3 Unit tests for `Int.formattedDuration` — round minutes, seconds padding, zero, one hour (6 cases)
- [x] 10.4 Unit tests for `String.parseDurationToSeconds()` — valid inputs, letters, seconds ≥ 60, no colon, empty, too many colons, negative seconds (10 cases)
