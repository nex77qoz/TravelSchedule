import SwiftUI

struct StoriesTabView: View {
    @Binding var stories: [Story]
    @Binding var storyIndex: Int
    @Binding var currentPage: Int

    var body: some View {
        TabView(selection: $storyIndex) {
            ForEach(stories.indices, id: \.self) { index in
                StoryPagesTabView(
                    pages: stories[index].totalPages,
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
            ForEach(pages.indices, id: \.self) { index in
                StoryPageView(model: pages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    StoriesTabView(
        stories: .constant(Story.mockData),
        storyIndex: .constant(1),
        currentPage: .constant(0)
    )
}
