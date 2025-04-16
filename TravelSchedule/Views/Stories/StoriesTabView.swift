import SwiftUI

struct StoriesTabView: View {
    @Binding var stories: [Story]
    @Binding var storyIndex: Int
    @Binding var currentPage: Int

    var body: some View {
        TabView(selection: $storyIndex) {
            ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                StoryPagesTabView(
                    pages: story.totalPages,
                    currentPage: $currentPage
                )
                .tag(index)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

private struct StoryPagesTabView: View {
    let pages: [StoryPage]
    @Binding var currentPage: Int

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                StoryPageView(model: page)
                    .tag(index)
            }
        }
    }
}

#Preview {
    StoriesTabView(
        stories: .constant(Story.mockData),
        storyIndex: .constant(1),
        currentPage: .constant(0)
    )
}
