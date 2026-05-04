import SwiftUI
import Combine

struct PerformanceView: View {
    let set: ComedySet

    @Environment(SetStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var startDate: Date = .now
    @State private var elapsed: TimeInterval = 0
    @State private var currentIndex: Int = 0
    @State private var showingExitAlert = false
    @State private var dwellTimes: [TimeInterval] = []
    @State private var lastIndexChangeDate: Date = .now

    private let timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var isFin: Bool { currentIndex == set.bits.count }

    private var remaining: TimeInterval {
        TimeInterval(set.durationSeconds) - elapsed
    }

    private var isOvertime: Bool { remaining < 0 }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                timerDisplay
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)
                    .padding(.bottom, 16)

                progressBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                ZStack(alignment: .bottomLeading) {
                    promptArea
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !isFin { advance(to: currentIndex + 1) }
                        }

                    Button {
                        if currentIndex > 0 { advance(to: currentIndex - 1) }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .opacity(currentIndex == 0 ? 0.3 : 1.0)
                            .padding(24)
                    }
                    .disabled(currentIndex == 0)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("End") {
                    if remaining > 0 && !isFin {
                        showingExitAlert = true
                    } else {
                        saveAndDismiss()
                    }
                }
                .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert("End Set?", isPresented: $showingExitAlert) {
            Button("End Set", role: .destructive) { saveAndDismiss() }
            Button("Continue", role: .cancel) { }
        } message: {
            Text("You still have time remaining. End the set early?")
        }
        .onAppear {
            startDate = .now
            elapsed = 0
            dwellTimes = Array(repeating: 0, count: set.bits.count)
            lastIndexChangeDate = .now
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(timerPublisher) { _ in
            guard !isFin else { return }
            elapsed = Date.now.timeIntervalSince(startDate)
        }
        .preferredColorScheme(.dark)
    }

    private var timerDisplay: some View {
        Text(formatTime(abs(remaining)))
            .font(.system(size: 80, weight: .thin, design: .monospaced))
            .foregroundStyle(isOvertime ? Color.red : Color.white)
            .monospacedDigit()
            .contentTransition(.numericText())
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            ForEach(0..<set.bits.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(segmentColor(for: index))
                    .frame(height: 6)
            }
        }
    }

    private func segmentColor(for index: Int) -> Color {
        if index < currentIndex { return .white.opacity(0.4) }
        if index == currentIndex { return .white }
        return .white.opacity(0.15)
    }

    private var promptArea: some View {
        VStack {
            if isFin {
                Text("FIN")
                    .font(.system(size: 80, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)
            } else if !set.bits.isEmpty {
                Text(set.bits[currentIndex])
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // Accumulates dwell on the outgoing index, resets the clock, moves to newIndex.
    private func advance(to newIndex: Int) {
        let now = Date.now
        if currentIndex < set.bits.count {
            dwellTimes[currentIndex] += now.timeIntervalSince(lastIndexChangeDate)
        }
        lastIndexChangeDate = now
        currentIndex = newIndex
    }

    private func flushCurrentDwell() {
        guard currentIndex < set.bits.count else { return }
        dwellTimes[currentIndex] += Date.now.timeIntervalSince(lastIndexChangeDate)
    }

    private func saveAndDismiss() {
        flushCurrentDwell()
        var updated = set
        updated.lastRunBitDurations = dwellTimes
        store.update(updated)
        dismiss()
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let total = Int(interval)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
