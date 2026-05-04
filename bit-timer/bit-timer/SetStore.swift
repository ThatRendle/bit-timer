import Foundation
import SwiftUI
import Observation

@Observable
final class SetStore {
    var sets: [ComedySet] = []

    init() {
        load()
    }

    func add(_ set: ComedySet) {
        sets.append(set)
        save()
    }

    func update(_ set: ComedySet) {
        guard let i = sets.firstIndex(where: { $0.id == set.id }) else { return }
        var updated = set
        if set.bits.count != sets[i].bits.count {
            updated.lastRunBitDurations = nil
        }
        sets[i] = updated
        save()
    }

    func delete(at offsets: IndexSet) {
        sets.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard let url = setsFileURL,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([ComedySet].self, from: data)
        else { return }
        sets = decoded
    }

    func save() {
        guard let url = setsFileURL,
              let data = try? JSONEncoder().encode(sets)
        else { return }
        try? data.write(to: url)
    }

    private var setsFileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("sets.json")
    }
}
