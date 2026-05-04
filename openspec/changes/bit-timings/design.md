## Context

`ComedySet` is a flat `Codable` struct persisted to `Documents/sets.json`. `PerformanceView` is a stateful SwiftUI view that owns all timer and navigation logic. The change touches four files: the model, the performance view, the editor, and the preview.

## Goals / Non-Goals

**Goals:**
- Record total dwell time per bit index across a single performance run
- Persist timings on `ComedySet` and display them in `SetPreviewView`
- Add a FIN page as the terminal state of a performance, freezing the timer
- Clear stale timings when a set is edited

**Non-Goals:**
- Multiple run history
- Per-bit time budgets or targets
- Colour coding or any visual judgement of timings
- Timing the FIN page itself

## Decisions

### Dwell time accumulation: delta on index change

Track a `lastIndexChangeDate: Date` alongside a `dwellTimes: [TimeInterval]` array initialised to `[0] * bits.count`. On every index change (forward or back), add `Date.now - lastIndexChangeDate` to `dwellTimes[oldIndex]` and reset `lastIndexChangeDate`. On reaching FIN or dismissing, flush the current index's accumulated time.

**Alternative considered**: record absolute timestamps for each bit arrival and compute durations at the end. Rejected — requires an array of optionals and is harder to reason about for back-navigation.

### FIN page: index == bits.count

Extend the navigable index range to `0...bits.count`. When `currentIndex == bits.count`, render the FIN page and stop the timer publisher from updating `elapsed`. The progress bar shows all segments filled.

**Alternative considered**: a separate boolean `isFinished` state flag. Rejected — index naturally expresses position; a separate flag adds redundant state that must be kept in sync.

### Timer freeze on FIN: stop updating elapsed

When `currentIndex == bits.count`, `onReceive` still fires but the handler skips updating `elapsed`. This freezes the display without cancelling the publisher (avoiding lifecycle complexity).

**Alternative considered**: cancel the publisher on FIN. More correct but adds cancellable state management for minimal benefit — the display is already frozen.

### Clear timings on edit: in SetStore.update()

Rather than in `SetEditorView`, clear `lastRunBitDurations` inside `SetStore.update(_:)` whenever the incoming set's `bits` count differs from the stored set's. This keeps the clearing logic out of the view and co-located with persistence.

**Alternative considered**: always clear on any edit. Rejected — if a user only changes the name or duration, the bit timings remain valid.

### Backwards-compatible JSON decode

`lastRunBitDurations` is decoded with `decodeIfPresent`, so existing `sets.json` files without the key decode cleanly to `nil`. No migration needed.

## Risks / Trade-offs

- **Back-navigation timing**: Total dwell time is accumulated across all visits to a bit index. A performer who taps back repeatedly will inflate that bit's recorded time. Accepted — this is the intended behaviour (total time experienced by the audience).
- **Dismiss without reaching FIN**: If the user exits mid-set, timings up to the current bit are saved. The remaining bits get `0` dwell time in the stored array. The preview will show zeros for unplayed bits, which is accurate.
- **Timer freeze granularity**: `elapsed` is updated once per second. The frozen value may be up to 1 second stale when FIN is reached. Acceptable for this use case.

## Open Questions

- None — scope is fully defined.
