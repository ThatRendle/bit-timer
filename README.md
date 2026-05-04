# Bit Timer

A native iPhone app for stand-up comedians to run a set.

- **Countdown timer** for the full set, turning red and counting up when overtime
- **Bit prompts** displayed one at a time, advanced by tap with a back button for mis-taps
- **Segmented progress bar** showing position within the set
- **FIN page** at the end of the set — freezes the timer and signals a clean finish
- **Per-bit timing** — records how long you actually spent on each bit and shows it in the set preview after the run
- **Multiple named sets** stored on-device, created by pasting a markdown bullet list
- Screen stays awake during performance

## Requirements

- Xcode 26+
- iOS 26+

## Building

Open `bit-timer/bit-timer.xcodeproj` in Xcode and run on a device or simulator.

No third-party dependencies.

## Creating a Set

In the Set Editor, enter a name, a duration in `MM:SS` format, and a list of bit prompts as a markdown bullet list:

```
- Opening crowd work
- The bit about the airport
- Callback to the opener
```

Each bullet line becomes one prompt in the performance view. Lines without a bullet prefix are ignored.

## License

Mozilla Public License 2.0 — see [LICENSE](LICENSE).
