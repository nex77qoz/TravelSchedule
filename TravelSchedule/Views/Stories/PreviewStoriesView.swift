import SwiftUI

struct PreviewStoriesView: View {
    private let rows = [GridItem(.flexible())]
    @State var stories: [Story] = Story.mockData
    @State var isStoriesShowing = false
    @State var storyIndex = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            previews
        }
        .frame(height: 188.0)
    }
}

private extension PreviewStoriesView {
    var previews: some View {
        LazyHGrid(rows: rows, alignment: .center, spacing: .M) {
            ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                StoryPreviewView(storyPreview: story)
                    .onTapGesture {
                        isStoriesShowing = true
                        storyIndex = index
                    }
                    .fullScreenCover(isPresented: $isStoriesShowing, onDismiss: didDismiss) {
                        StoriesView(stories: $stories, storyIndex: $storyIndex)
                    }
            }
        }
        .padding(.horizontal, .L)
        .padding(.vertical, .XXL)
    }
}

private extension PreviewStoriesView {
    func didDismiss() {
        isStoriesShowing = false
    }
}

#Preview {
    PreviewStoriesView(stories: Story.mockData)
}
