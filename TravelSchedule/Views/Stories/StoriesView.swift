import SwiftUI
import Combine

struct StoriesView: View {
    private let almostZero = 0.01
    private let full = 1.0
    private let firstStoryIndex = 0
    private let firstPage = 0

    private var lastStoryIndex: Int { stories.count - 1 }
    private var timer: TimerConfiguration { .init(totalPages: totalPages) }
    private var totalPages: Int { stories[storyIndex].totalPages.count }
    private var lastPage: Int { totalPages - 1 }

    @State var currentPage: Int = 0
    @State var currentProgress: CGFloat = 0

    @Binding var stories: [Story]
    @Binding var storyIndex: Int

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Color.ypBlack
            .ignoresSafeArea()
            .overlay {
                ZStack(alignment: .topTrailing) {
                    fullCoverStory
                    progressBar
                    closeButton
                }
                .onChange(of: storyIndex) { [storyIndex] newValue in
                    didChangeStory(oldStory: storyIndex, newStory: newValue)
                }
                .onChange(of: currentPage) { [currentPage] newValue in
                    didChangePage(oldPage: currentPage, newPage: newValue)
                }
                .onChange(of: currentProgress) { newValue in
                    didChangeProgress(newProgress: newValue)
                }
                .onTapGesture { location in
                    didTapStoryPage(at: location)
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            didSwipeDown(gesture: gesture)
                        }
                )
            }
    }
}

private extension StoriesView {
    var fullCoverStory: some View {
        StoriesTabView(
            stories: $stories,
            storyIndex: $storyIndex,
            currentPage: $currentPage
        )
    }

    var progressBar: some View {
        StoriesProgressBarView(
            pagesCount: totalPages,
            timerConfiguration: timer,
            progress: $currentProgress
        )
    }

    var closeButton: some View {
        Button {
            handleDismiss()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color.ypWhite)
                Image.cancel
                    .resizable()
                    .foregroundStyle(Color.ypBlack)
            }
            .frame(width: 30.0, height: 30.0)
        }
        .padding(.top, 57.0)
        .padding(.trailing, .S)
    }
}

private extension StoriesView {
    func didChangePage(oldPage: Int, newPage: Int) {
        let progress = timer.progress(for: newPage)
        guard oldPage != newPage, abs(progress - currentProgress) >= almostZero else { return }
        currentProgress = progress
    }

    func didChangeStory(oldStory: Int, newStory: Int) {
        switch newStory {
            case ...oldStory: currentPage = lastPage
            case oldStory...: currentPage = firstPage
            default: break
        }
    }

    func didChangeProgress(newProgress: CGFloat) {
        if currentProgress == full && newProgress == full {
            showNext()
        }
        let pageIndex = timer.index(for: newProgress)
        if pageIndex != currentPage {
            withAnimation {
                currentPage = pageIndex
            }
        }
    }

    @MainActor
    func didTapStoryPage(at location: CGPoint) {
        let halfScreen = UIScreen.main.bounds.width / 2
        switch (currentPage, location.x) {
            case (firstPage, ...halfScreen):
                showPrevious()
            case (lastPage, halfScreen...):
                showNext()
            default:
                withAnimation {
                    currentPage = location.x < halfScreen
                    ? max(currentPage - 1, 0)
                    : min(currentPage + 1, totalPages - 1)
                }
        }
    }

    func didSwipeDown(gesture: DragGesture.Value) {
        switch (gesture.translation.width, gesture.translation.height) {
            case (-30...30, 0...): handleDismiss()
            default: break
        }
    }

    func handleDismiss() {
        dismiss()
    }

    func showNext() {
        stories[storyIndex].isShowed = true
        if storyIndex == lastStoryIndex && currentPage == lastPage {
            handleDismiss()
        } else {
            withAnimation {
                storyIndex += 1
            }
        }
    }

    func showPrevious() {
        if currentPage > firstPage {
            withAnimation {
                currentPage -= 1
            }
        }
        if storyIndex > firstStoryIndex {
            withAnimation {
                storyIndex -= 1
            }
        }
    }
}

#Preview {
    StoriesView(stories: .constant(Story.mockData), storyIndex: .constant(2))
}
