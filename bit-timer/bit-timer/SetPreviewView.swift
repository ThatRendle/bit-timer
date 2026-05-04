import SwiftUI

struct SetPreviewView: View {
    @Environment(SetStore.self) private var store
    let set: ComedySet

    @State private var showingEditor = false
    @State private var showingPerformance = false

    private var current: ComedySet {
        store.sets.first(where: { $0.id == set.id }) ?? set
    }

    var body: some View {
        List {
            Section {
                LabeledContent("Duration", value: current.durationSeconds.formattedDuration)
                LabeledContent("Bits", value: "\(current.bits.count)")
            }

            Section("Bits") {
                ForEach(Array(current.bits.enumerated()), id: \.offset) { index, bit in
                    HStack {
                        Text("\(index + 1). \(bit)")
                            .font(.body)
                        Spacer()
                        if let timings = current.lastRunBitDurations, index < timings.count {
                            Text(timings[index].formattedDwell)
                                .font(.body.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(current.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showingEditor = true }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showingPerformance = true
            } label: {
                Text("Start")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .background(.background)
        }
        .sheet(isPresented: $showingEditor) {
            SetEditorView(existingSet: current)
        }
        .navigationDestination(isPresented: $showingPerformance) {
            PerformanceView(set: current)
        }
    }
}
