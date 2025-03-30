import SwiftUI
import Combine

struct StoryProgressBarView: View {
    // MARK: - Константы и свойства
    let pagesCount: Int
    let timerConfiguration: TimerConfiguration

    @Binding var progress: CGFloat
    @State private var timerPublisher: Timer.TimerPublisher
    @State private var timerCancellable: Cancellable?

    // MARK: - Основное представление
    var body: some View {
        SegmentedProgressBar(numberOfSections: pagesCount, progress: progress)
            .padding(.top, 35)
            .padding(.horizontal, .spacerS)
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
            .onReceive(timerPublisher) { _ in
                withAnimation {
                    progress = timerConfiguration.nextProgress(progress: progress)
                }
            }
    }

    // MARK: - Инициализация
    init(pagesCount: Int, timerConfiguration: TimerConfiguration, progress: Binding<CGFloat>) {
        self.pagesCount = pagesCount
        self.timerConfiguration = timerConfiguration
        self._progress = progress
        self._timerPublisher = State(initialValue: Self.makeTimer(with: timerConfiguration))
    }

    // MARK: - Логика таймера
    private func startTimer() {
        timerPublisher = Self.makeTimer(with: timerConfiguration)
        timerCancellable = timerPublisher.connect()
    }

    private func stopTimer() {
        timerCancellable?.cancel()
    }
}

// MARK: - Вспомогательные методы
private extension StoryProgressBarView {
    static func makeTimer(with configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}

#Preview {
    StoryProgressBarView(
        pagesCount: 3,
        timerConfiguration: TimerConfiguration(pagesCount: 3),
        progress: .constant(0.5)
    )
    .background(
        Color.ypRed.opacity(0.5)
    )
}
