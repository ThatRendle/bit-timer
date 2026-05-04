## Context

Brand new iOS app built on an empty Xcode 26 SwiftUI template (`bit_timerApp.swift` + `ContentView.swift`). No existing code to integrate with. The app is a single-user, offline-only performance tool — no backend, no sync, no accounts.

The primary use context is live performance: phone in left hand, one thumb available. UI decisions must favour glanceability and mis-tap recovery over feature density.

## Goals / Non-Goals

**Goals:**
- Four-screen app: Set List → Set Preview → Performance View (+ Set Editor as a sheet)
- Fast, reliable countdown timer with overtime mode
- Tap-to-advance slide navigation with back recovery
- Local JSON persistence for multiple named sets
- Screen kept awake during performance

**Non-Goals:**
- Cloud sync, sharing, or export
- Audio/haptic alerts
- Per-bit time budgets
- Landscape orientation

## Decisions

### Navigation: NavigationStack with type-safe routing

Use a single `NavigationStack` at root with `navigationDestination(for:)` for `ComedySet` (list → preview) and a separate `.sheet` for the editor. This is the idiomatic SwiftUI approach in iOS 16+ and avoids coordinator boilerplate.

**Alternative considered**: TabView — rejected, wrong mental model for a linear flow.

### State: `@Observable` store class injected via environment

A single `SetStore: Observable` class owns the array of `ComedySet` values and handles persistence. Injected with `.environment(store)` at the root so all views can read/write without prop-drilling.

**Alternative considered**: `@AppStorage` with JSON encoding — works but bypasses the store abstraction, making it harder to add validation later.

### Persistence: JSON file in Documents directory

Encode `[ComedySet]` as JSON and write to `documents/sets.json`. Load on app launch. Simple, inspectable, portable.

**Alternative considered**: SwiftData — better query support, but overkill for a flat list of small structs. Adds migration complexity for zero benefit here.

### Markdown parsing: manual line-by-line, no library

Strip leading `- `, `* `, or `• ` from each non-empty trimmed line. One line = one bit. No sub-bullet support. Implemented as a `String` extension — avoids any dependency and is trivial to test.

**Alternative considered**: `swift-markdown` package — unnecessary weight for a single parsing rule.

### Timer: `TimeInterval` elapsed + `Timer.publish`

Store `startDate: Date` when the set starts. Each tick computes `elapsed = Date.now - startDate`. Remaining = `durationSeconds - elapsed`. When remaining < 0, display overtime as `abs(remaining)` in red. This survives backgrounding correctly (wall clock, not tick count).

**Alternative considered**: Decrementing a counter each second — drifts if app is backgrounded or ticks are skipped.

### Progress indicator: segmented bar (HStack of RoundedRectangle)

One segment per bit, filled accent colour for completed, grey for upcoming, highlight colour for current. Scales to any number of bits without segments becoming invisible (unlike dot arrays).

### Screen wake: `isIdleTimerDisabled` toggled with view lifecycle

Set `UIApplication.shared.isIdleTimerDisabled = true` in `.onAppear` and `false` in `.onDisappear` of `PerformanceView`. Scoped to the one view that needs it.

### Duration input: MM:SS text field with formatter

User types duration as `MM:SS` string. Validated and parsed to `Int` seconds on save. Invalid input shows inline error, blocks save.

## Risks / Trade-offs

- **Timer accuracy**: `Timer.publish` can fire late under load. Using wall-clock elapsed time mitigates drift, but the displayed second may occasionally skip. Acceptable for a comedy timer.
- **JSON write on every save**: Could cause a brief stall on very slow devices with large set lists. Unlikely to be noticeable; can move to background queue if it becomes a problem.
- **No undo in editor**: Destructive edits (clearing the markdown field) can't be undone. Mitigated by the confirmation dialog before exiting mid-set.

## Open Questions

- None — scope is fully defined.
