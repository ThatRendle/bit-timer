import Foundation
import Testing
@testable import bit_timer

// MARK: - parseBulletLines

@Suite("parseBulletLines")
struct ParseBulletLinesTests {

    @Test func dashPrefix() {
        #expect("- Hello".parseBulletLines() == ["Hello"])
    }

    @Test func asteriskPrefix() {
        #expect("* World".parseBulletLines() == ["World"])
    }

    @Test func bulletCharPrefix() {
        #expect("• Stuff".parseBulletLines() == ["Stuff"])
    }

    @Test func multipleLines() {
        let input = """
        - First bit
        - Second bit
        - Third bit
        """
        #expect(input.parseBulletLines() == ["First bit", "Second bit", "Third bit"])
    }

    @Test func mixedPrefixes() {
        let input = "- Dash\n* Asterisk\n• Bullet"
        #expect(input.parseBulletLines() == ["Dash", "Asterisk", "Bullet"])
    }

    @Test func emptyLinesIgnored() {
        let input = "- First\n\n- Second"
        #expect(input.parseBulletLines() == ["First", "Second"])
    }

    @Test func nonBulletLinesIgnored() {
        let input = "Some prose\n- Actual bit\nMore prose"
        #expect(input.parseBulletLines() == ["Actual bit"])
    }

    @Test func leadingAndTrailingWhitespaceStripped() {
        #expect("-   Spaced   ".parseBulletLines() == ["Spaced"])
    }

    @Test func emptyStringReturnsEmpty() {
        #expect("".parseBulletLines() == [])
    }

    @Test func bulletWithNoTextIgnored() {
        #expect("- ".parseBulletLines() == [])
    }
}

// MARK: - formattedDuration

@Suite("formattedDuration")
struct FormattedDurationTests {

    @Test func tenMinutes() {
        #expect(600.formattedDuration == "10:00")
    }

    @Test func fiveMinutesThirtySeconds() {
        #expect(330.formattedDuration == "5:30")
    }

    @Test func zero() {
        #expect(0.formattedDuration == "0:00")
    }

    @Test func oneMinute() {
        #expect(60.formattedDuration == "1:00")
    }

    @Test func nineSeconds() {
        #expect(9.formattedDuration == "0:09")
    }

    @Test func oneHour() {
        #expect(3600.formattedDuration == "60:00")
    }
}

// MARK: - parseDurationToSeconds

@Suite("parseDurationToSeconds")
struct ParseDurationTests {

    @Test func validTenMinutes() {
        #expect("10:00".parseDurationToSeconds() == 600)
    }

    @Test func validFiveThirty() {
        #expect("5:30".parseDurationToSeconds() == 330)
    }

    @Test func validZero() {
        #expect("0:00".parseDurationToSeconds() == 0)
    }

    @Test func validZeroMinutesNineSeconds() {
        #expect("0:09".parseDurationToSeconds() == 9)
    }

    @Test func invalidLetters() {
        #expect("abc".parseDurationToSeconds() == nil)
    }

    @Test func invalidSecondsOutOfRange() {
        #expect("5:60".parseDurationToSeconds() == nil)
    }

    @Test func invalidNoColon() {
        #expect("1000".parseDurationToSeconds() == nil)
    }

    @Test func invalidEmpty() {
        #expect("".parseDurationToSeconds() == nil)
    }

    @Test func invalidTooManyColons() {
        #expect("1:00:00".parseDurationToSeconds() == nil)
    }

    @Test func invalidNegativeSeconds() {
        #expect("5:-1".parseDurationToSeconds() == nil)
    }
}

// MARK: - Bit Timings

@Suite("BitTimings")
struct BitTimingsTests {

    @Test func lastRunBitDurationsCountMatchesBitCount() {
        let content = "- Bit one\n- Bit two\n- Bit three"
        let set = ComedySet(id: UUID(), name: "Test", durationSeconds: 600,
                            markdownContent: content,
                            lastRunBitDurations: [10, 20, 30])
        #expect(set.lastRunBitDurations?.count == set.bits.count)
    }

    @Test func updateClearsDurationsWhenBitCountChanges() {
        let store = SetStore()
        let id = UUID()
        let original = ComedySet(id: id, name: "Test", durationSeconds: 300,
                                 markdownContent: "- Bit one\n- Bit two",
                                 lastRunBitDurations: [10.0, 20.0])
        store.sets = [original]

        var edited = original
        edited.markdownContent = "- Bit one\n- Bit two\n- Bit three"
        store.update(edited)

        #expect(store.sets.first?.lastRunBitDurations == nil)
    }

    @Test func updatePreservesDurationsWhenBitCountUnchanged() {
        let store = SetStore()
        let id = UUID()
        let original = ComedySet(id: id, name: "Test", durationSeconds: 300,
                                 markdownContent: "- Bit one\n- Bit two",
                                 lastRunBitDurations: [10.0, 20.0])
        store.sets = [original]

        var edited = original
        edited.name = "Updated Name"
        store.update(edited)

        #expect(store.sets.first?.lastRunBitDurations == [10.0, 20.0])
    }
}
