import Foundation

struct ComedySet: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var durationSeconds: Int
    var markdownContent: String
    var lastRunBitDurations: [TimeInterval]?

    var bits: [String] {
        markdownContent.parseBulletLines()
    }
}

extension TimeInterval {
    var formattedDwell: String {
        let total = Int(self)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

extension String {
    func parseBulletLines() -> [String] {
        components(separatedBy: "\n")
            .compactMap { line -> String? in
                let t = line.trimmingCharacters(in: .whitespaces)
                if t.hasPrefix("- ") { return String(t.dropFirst(2)).trimmingCharacters(in: .whitespaces) }
                if t.hasPrefix("* ") { return String(t.dropFirst(2)).trimmingCharacters(in: .whitespaces) }
                if t.hasPrefix("•") { return String(t.dropFirst(1)).trimmingCharacters(in: .whitespaces) }
                return nil
            }
            .filter { !$0.isEmpty }
    }
}

extension Int {
    var formattedDuration: String {
        String(format: "%d:%02d", self / 60, self % 60)
    }
}

extension String {
    // Parses "MM:SS" into total seconds. Returns nil for any invalid input.
    func parseDurationToSeconds() -> Int? {
        let parts = split(separator: ":")
        guard parts.count == 2,
              let minutes = Int(parts[0]),
              let secs = Int(parts[1]),
              minutes >= 0, secs >= 0, secs < 60
        else { return nil }
        return minutes * 60 + secs
    }
}
