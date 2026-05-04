## 1. Data Model

- [x] 1.1 Add `lastRunBitDurations: [TimeInterval]?` to `ComedySet` (default `nil`)
- [x] 1.2 Update `SetStore.update(_:)` to clear `lastRunBitDurations` when the incoming set's bit count differs from the stored set's bit count

## 2. Performance View — FIN Page

- [x] 2.1 Extend navigable index range to `0...bits.count`; index `bits.count` is the FIN page
- [x] 2.2 Render "FIN" text on the FIN page in place of the bit prompt
- [x] 2.3 Fill all progress bar segments when on the FIN page
- [x] 2.4 Disable tap-to-advance on the FIN page
- [x] 2.5 Enable back button on the FIN page (returns to last bit)
- [x] 2.6 Allow dismissal from FIN page without confirmation alert

## 3. Performance View — Timer Freeze

- [x] 3.1 Skip updating `elapsed` in `onReceive` when `currentIndex == bits.count`
- [x] 3.2 Resume updating `elapsed` when user navigates back from FIN to the last bit

## 4. Performance View — Dwell Time Recording

- [x] 4.1 Add `dwellTimes: [TimeInterval]` state initialised to `[0] * bits.count`
- [x] 4.2 Add `lastIndexChangeDate: Date` state initialised to `startDate` on appear
- [x] 4.3 On every index change (forward or back, excluding FIN), accumulate `Date.now - lastIndexChangeDate` into `dwellTimes[oldIndex]` and reset `lastIndexChangeDate`
- [x] 4.4 On reaching FIN, flush `dwellTimes[lastBitIndex] += Date.now - lastIndexChangeDate`
- [x] 4.5 On dismiss (all paths — confirm exit, overtime exit, FIN exit), save `dwellTimes` to `store` by updating the set's `lastRunBitDurations`

## 5. Set Preview — Timing Display

- [x] 5.1 When `lastRunBitDurations` is non-nil, show each bit's dwell time formatted as `M:SS` alongside its prompt in the bit list
- [x] 5.2 When `lastRunBitDurations` is nil, show the bit list with no timing column (existing behaviour)

## 6. Tests

- [x] 6.1 Unit test: `parseBulletLines` result count matches `lastRunBitDurations` count after a run (model consistency)
- [x] 6.2 Unit test: `SetStore.update` clears timings when bit count changes
- [x] 6.3 Unit test: `SetStore.update` preserves timings when bit count is unchanged
