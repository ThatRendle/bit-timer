---
name: bit-timer-app
description: Initial build of the Bit Timer iOS app — a performance tool for stand-up comedians
type: proposal
status: approved
---

# Bit Timer App

## Summary

A native iPhone app for stand-up comedians to run a set. The top of the screen shows a countdown timer for the whole set; the bottom shows a scrollable slideshow of bit prompts, one at a time. Sets are created on-device using a markdown bullet list and stored locally.

## Problem

Performing a stand-up set requires knowing your material, your pacing, and how much time you have left — all at a glance, with one hand occupied. Existing timer apps don't understand the structure of a comedy set. Notes apps don't give you a countdown. This app combines both.

## Goals

- Countdown timer for the full set, turning red and counting up when overtime
- Bit prompts displayed one at a time, advanced by tap, with a back button for mis-taps
- Progress indicator showing position within the set
- Sets created by pasting a markdown bullet list (clipboard-friendly from Mac)
- Multiple named sets stored on-device
- Screen stays awake during performance

## Non-goals

- No audio cues or haptic alerts
- No sync to cloud or other devices
- No landscape orientation support
- No per-bit time budgets
- No sharing or export of sets

## Screens

### 1. Set List (home)
List of saved sets showing name and duration. Tap a set to go to Preview. Button to create a new set.

### 2. Set Editor
- Name field
- Duration field (MM:SS)
- Multiline text area for markdown bullet list (each `- ` bullet = one bit prompt)

### 3. Set Preview
- Set name, duration, bit count
- Scrollable list of all prompts (numbered)
- **Start** button → enters Performance view
- **Edit** button → opens Set Editor for this set

### 4. Performance View
- **Top**: large countdown timer (white). Turns red and counts up as overtime when it hits 0:00
- **Middle**: progress dots or segmented bar — one segment per bit, filled as you advance
- **Bottom**: current bit prompt in large text, centered
- Tap anywhere on the bottom half to advance to next bit
- Back button (bottom-left) to go to previous bit
- Screen kept awake via `isIdleTimerDisabled`
- Dismiss returns to Set Preview (with confirmation prompt if mid-set)

## Data Model

```swift
struct ComedySet: Codable, Identifiable {
    var id: UUID
    var name: String
    var durationSeconds: Int       // parsed from MM:SS input
    var markdownContent: String    // raw user input, stored as-is
    var bits: [String]             // derived: parsed bullet points
}
```

Sets persisted to JSON in the app's Documents directory.

Markdown parsing: strip leading `- `, `* `, or `• ` from each non-empty line. One line = one bit. Sub-bullets ignored.

## Tech Stack

- Swift + SwiftUI
- Xcode 26, iOS 26 target
- No third-party dependencies
- Local JSON file for persistence (no CoreData, no SwiftData)
- `UIApplication.shared.isIdleTimerDisabled` toggled on/off with Performance view lifecycle

## Starting point

Xcode project already created at `bit-timer/bit-timer/` with standard SwiftUI App template.
Entry point: `bit_timerApp.swift` → `ContentView.swift`
