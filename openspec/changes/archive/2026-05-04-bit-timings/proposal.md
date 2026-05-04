---
name: bit-timings
description: Record dwell time per bit during a performance and display in Set Preview; add a FIN page to close out the set
type: proposal
status: approved
---

## Why

Performers want to know how long they actually spent on each bit — not a budget, just a record. This turns the app from a countdown tool into a lightweight performance log. A FIN page also gives a clean ending UX and a natural point to freeze the timer and flush the final bit's timing.

## What Changes

- `ComedySet` gains `lastRunBitDurations: [TimeInterval]?` — `nil` until the first performance, overwritten on each subsequent run
- `PerformanceView` accumulates total dwell time per bit index on every forward and back navigation, flushes the final bit's time on dismiss or FIN
- `PerformanceView` gains a FIN page beyond the last bit: tapping the last bit's prompt advances to FIN, which displays "FIN" and freezes the timer at whatever value it held at that moment
- `SetEditorView` clears `lastRunBitDurations` on save, because a structural edit (bits added or removed) makes stored timings stale
- `SetPreviewView` shows per-bit timings in the bit list when `lastRunBitDurations` is present

## Capabilities

### New Capabilities

- `bit-timing`: Recording, storing, and displaying per-bit dwell time from a live performance

### Modified Capabilities

- `performance-view`: Adds FIN page, dwell-time accumulation, and timer freeze on FIN
- `set-management`: `ComedySet` data model gains `lastRunBitDurations`
- `set-editor`: Clears timings on save

## Impact

- `ComedySet.swift` — new optional field (JSON-compatible, backwards-compatible decode via `decodeIfPresent`)
- `PerformanceView.swift` — dwell tracking state, FIN page rendering, timer freeze, save-on-dismiss
- `SetEditorView.swift` — clear timings on successful save
- `SetPreviewView.swift` — conditional timing column in bit list
- Existing `sets.json` files decode cleanly (missing key → `nil`)
