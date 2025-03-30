import SwiftUI

struct StoriesTabView: View {
    // MARK: - Свойства
    @Binding var stories: [Story]
    @Binding var storyIndex: Int
    @Binding var currentPage: Int

    // MARK: - Основное представление
    var body: some View {
        TabView(selection: $storyIndex) {
            ForEach(Array(stories.enumerated()), id: \.offset) { storyIndex, story in
                storyPagesTabView(for: story)
                    .tag(storyIndex)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func storyPagesTabView(for story: Story) -> some View {
        TabView(selection: $currentPage) {
            ForEach(Array(story.storyPages.enumerated()), id: \.offset) { pageIndex, page in
                StorySlideView(slide: page)
                    .tag(pageIndex)
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
