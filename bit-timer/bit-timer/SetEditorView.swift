import SwiftUI

struct SetEditorView: View {
    @Environment(SetStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var existingSet: ComedySet? = nil

    @State private var name = ""
    @State private var durationText = ""
    @State private var markdownContent = ""

    @State private var nameError: String? = nil
    @State private var durationError: String? = nil
    @State private var bitsError: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Set name", text: $name)
                    if let error = nameError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }

                Section("Duration (MM:SS)") {
                    TextField("e.g. 10:00", text: $durationText)
                        .keyboardType(.numbersAndPunctuation)
                    if let error = durationError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }

                Section("Bits") {
                    TextEditor(text: $markdownContent)
                        .frame(minHeight: 200)
                        .font(.body.monospaced())
                    if let error = bitsError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }
            }
            .navigationTitle(existingSet == nil ? "New Set" : "Edit Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { attemptSave() }
                }
            }
            .onAppear {
                guard let set = existingSet else { return }
                name = set.name
                durationText = set.durationSeconds.formattedDuration
                markdownContent = set.markdownContent
            }
        }
    }

    private func attemptSave() {
        nameError = nil
        durationError = nil
        bitsError = nil

        var valid = true

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Name is required."
            valid = false
        }

        let seconds = durationText.parseDurationToSeconds()
        if seconds == nil {
            durationError = "Enter duration as MM:SS (e.g. 10:00)."
            valid = false
        }

        if markdownContent.parseBulletLines().isEmpty {
            bitsError = "Enter at least one bullet point (-, *, or •)."
            valid = false
        }

        guard valid, let seconds else { return }

        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        if var set = existingSet {
            set.name = trimmedName
            set.durationSeconds = seconds
            set.markdownContent = markdownContent
            store.update(set)
        } else {
            store.add(ComedySet(
                id: UUID(),
                name: trimmedName,
                durationSeconds: seconds,
                markdownContent: markdownContent
            ))
        }
        dismiss()
    }

}
