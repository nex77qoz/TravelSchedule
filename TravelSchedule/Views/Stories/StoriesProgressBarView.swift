import SwiftUI
import Combine

struct StoriesProgressBarView: View {
    @Binding var progress: CGFloat
    let pagesCount: Int
    let timerConfiguration: TimerConfiguration

    @State private var cancelable: Cancellable?
    @State private var timer: Timer.TimerPublisher

    init(pagesCount: Int, timerConfiguration: TimerConfiguration, progress: Binding<CGFloat>) {
        self._progress = progress
        self.pagesCount = pagesCount
        self.timerConfiguration = timerConfiguration
        self._timer = State(initialValue: Self.createTimer(configuration: timerConfiguration))
    }

    var body: some View {
        ProgressBarView(numberOfSections: pagesCount, progress: progress)
            .padding(.top, 3)
            .padding(.horizontal, .S)
            .onAppear {
                cancelable = timer.connect()
            }
            .onDisappear {
                cancelable?.cancel()
            }
            .onReceive(timer) { _ in
                withAnimation {
                    progress = timerConfiguration.nextProgress(progress: progress)
                }
            }
    }
}

private extension StoriesProgressBarView {
    static func createTimer(configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.tickInterval, on: .main, in: .common)
    }
}

#Preview {
    StoriesProgressBarView(
        pagesCount: 3,
        timerConfiguration: TimerConfiguration(totalPages: 3),
        progress: .constant(0.5)
    )
    .background(Color.ypRed.opacity(0.5))
}
