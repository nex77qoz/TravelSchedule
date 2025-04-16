import SwiftUI
import Combine

struct StoriesProgressBarView: View {
    let pagesCount: Int
    let timerConfiguration: TimerConfiguration

    @Binding var progress: CGFloat
    @State private var timer: Timer.TimerPublisher
    @State private var cancelable: Cancellable?

    var body: some View {
        ProgressBarView(numberOfSections: pagesCount, progress: progress)
            .padding(.top, 3.0)
            .padding(.horizontal, .S)
            .onAppear {
                timer = Self.createTimer(configuration: timerConfiguration)
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

    init(pagesCount: Int, timerConfiguration: TimerConfiguration, progress: Binding<CGFloat>) {
        self.pagesCount = pagesCount
        self.timerConfiguration = timerConfiguration
        self._progress = progress
        self.timer = Self.createTimer(configuration: timerConfiguration)
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
    .background(
        Color.ypRed.opacity(0.5)
    )
}
