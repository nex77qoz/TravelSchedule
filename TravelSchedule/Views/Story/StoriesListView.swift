import SwiftUI
import Combine

struct StoriesView: View {
    // MARK: - Константы
    private let epsilon: CGFloat = 0.01
    private let fullProgress: CGFloat = 1.0
    private let firstStoryIndex = 0
    private let firstPageIndex = 0

    // MARK: - Вычисляемые свойства
    private var lastStoryIndex: Int { stories.count - 1 }
    private var pagesCount: Int { stories[storyIndex].storyPages.count }
    private var lastPageIndex: Int { pagesCount - 1 }
    private var timerConfiguration: TimerConfiguration { TimerConfiguration(pagesCount: pagesCount) }

    // MARK: - Состояния
    @State private var currentPage: Int = 0
    @State private var currentProgress: CGFloat = 0
    @State private var previousStoryIndex: Int = 0
    @State private var previousPage: Int = 0

    @Binding var stories: [Story]
    @Binding var storyIndex: Int

    @Environment(\.dismiss) private var dismiss

    // MARK: - Основное представление
    var body: some View {
        Color.ypBlack
            .ignoresSafeArea()
            .overlay(overlayContent)
    }

    // MARK: - Вспомогательное представление
    private var overlayContent: some View {
        ZStack(alignment: .topTrailing) {
            StoriesTabView(
                stories: $stories,
                storyIndex: $storyIndex,
                currentPage: $currentPage
            )

            StoryProgressBarView(
                pagesCount: pagesCount,
                timerConfiguration: timerConfiguration,
                progress: $currentProgress
            )

            CloseButton(action: handleDismiss)
                .padding(.top, 57)
                .padding(.trailing, .spacerS)
        }
        .onChange(of: storyIndex) { newValue in
            updateForStoryChange(oldIndex: previousStoryIndex, newIndex: newValue)
            previousStoryIndex = newValue
        }
        .onChange(of: currentPage) { newValue in
            updateForPageChange(oldIndex: previousPage, newIndex: newValue)
            previousPage = newValue
        }
        .onChange(of: currentProgress) { newProgress in
            updateForProgressChange(newProgress: newProgress)
        }
        .onTapGesture { location in
            handleTap(at: location)
        }
        .gesture(
            DragGesture().onEnded(handleSwipe)
        )
        .onAppear {
            previousStoryIndex = storyIndex
            previousPage = currentPage
        }
    }

    // MARK: - Методы обновления состояния
    private func updateForPageChange(oldIndex: Int, newIndex: Int) {
        let targetProgress = timerConfiguration.progress(for: newIndex)
        guard oldIndex != newIndex, abs(targetProgress - currentProgress) >= epsilon else { return }
        currentProgress = targetProgress
    }

    private func updateForStoryChange(oldIndex: Int, newIndex: Int) {
        if newIndex <= oldIndex {
            currentPage = lastPageIndex
        } else {
            currentPage = firstPageIndex
        }
    }

    private func updateForProgressChange(newProgress: CGFloat) {
        if currentProgress == fullProgress && newProgress == fullProgress {
            showNextStory()
        }
        let pageIndex = timerConfiguration.index(for: newProgress)
        if pageIndex != currentPage {
            withAnimation {
                currentPage = pageIndex
            }
        }
    }

    // MARK: - Обработка жестов и нажатий
    private func handleTap(at location: CGPoint) {
        let halfScreen = UIScreen.main.bounds.width / 2
        if currentPage == firstPageIndex && location.x <= halfScreen {
            showPreviousStory()
        } else if currentPage == lastPageIndex && location.x >= halfScreen {
            showNextStory()
        } else {
            withAnimation {
                currentPage = location.x < halfScreen
                    ? max(currentPage - 1, 0)
                    : min(currentPage + 1, pagesCount - 1)
            }
        }
    }

    private func handleSwipe(_ gesture: DragGesture.Value) {
        if (-30...30).contains(gesture.translation.width) && gesture.translation.height >= 0 {
            handleDismiss()
        }
    }

    // MARK: - Управление навигацией
    private func handleDismiss() {
        dismiss()
    }

    private func showNextStory() {
        stories[storyIndex].isShowed = true
        if storyIndex == lastStoryIndex && currentPage == lastPageIndex {
            handleDismiss()
        } else {
            withAnimation {
                storyIndex += 1
            }
        }
    }

    private func showPreviousStory() {
        if currentPage > firstPageIndex {
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
