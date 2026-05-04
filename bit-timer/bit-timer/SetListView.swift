import SwiftUI

struct SetListView: View {
    @Environment(SetStore.self) private var store
    @State private var showingEditor = false

    var body: some View {
        NavigationStack {
            Group {
                if store.sets.isEmpty {
                    ContentUnavailableView(
                        "No Sets",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Tap \"New Set\" to create your first comedy set.")
                    )
                } else {
                    List {
                        ForEach(store.sets) { set in
                            NavigationLink(value: set) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(set.name)
                                        .font(.headline)
                                    Text(set.durationSeconds.formattedDuration)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Sets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Set") { showingEditor = true }
                }
            }
            .navigationDestination(for: ComedySet.self) { set in
                SetPreviewView(set: set)
            }
            .sheet(isPresented: $showingEditor) {
                SetEditorView()
            }
        }
    }
}
