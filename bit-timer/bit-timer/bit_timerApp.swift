import SwiftUI

@main
struct bit_timerApp: App {
    private let store = SetStore()

    var body: some Scene {
        WindowGroup {
            SetListView()
                .environment(store)
        }
    }
}
