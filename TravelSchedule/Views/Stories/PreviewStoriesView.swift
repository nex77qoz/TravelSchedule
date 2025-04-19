import SwiftUI

struct PreviewStoriesView: View {
    @State private var stories: [Story] = Story.mockData
    @State private var storyIndex: Int = 0
    @State private var isStoriesShowing: Bool = false

    private let rows = [GridItem(.flexible())]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .center, spacing: .M) {
                ForEach(stories.indices, id: \.self) { index in
                    let story = stories[index]
                    StoryPreviewView(storyPreview: story)
                        .onTapGesture {
                            storyIndex = index
                            isStoriesShowing = true
                        }
                }
            }
            .padding(.horizontal, .L)
            .padding(.vertical, .XXL)
        }
        .frame(height: 188)
        .fullScreenCover(isPresented: $isStoriesShowing, onDismiss: {
            isStoriesShowing = false
        }) {
            StoriesView(stories: $stories, storyIndex: $storyIndex)
        }
    }
}

#Preview {
    PreviewStoriesView()
}
