import Foundation

struct TimerConfiguration: Sendable {
    let totalPages: Int
    let tickInterval: TimeInterval
    let progressIncrement: CGFloat

    init(
        totalPages: Int,
        secondsPerStory: TimeInterval = 5,
        tickInterval: TimeInterval = 0.25
    ) {
        self.totalPages = totalPages
        self.tickInterval = tickInterval
        self.progressIncrement = 1.0 / CGFloat(totalPages) / secondsPerStory * tickInterval
    }

    func progress(for storyIndex: Int) -> CGFloat {
        min(CGFloat(storyIndex) / CGFloat(totalPages), 1)
    }

    func index(for progress: CGFloat) -> Int {
        min(Int(progress * CGFloat(totalPages)), totalPages - 1)
    }

    func nextProgress(progress: CGFloat) -> CGFloat {
        min(progress + progressIncrement, 1)
    }
}
