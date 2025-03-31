import SwiftUI

struct PreviewStoriesView: View {
    // MARK: - Константы
    private let rows = [GridItem(.flexible())]

    // MARK: - Свойства
    @Binding var stories: [Story]

    @State var isStoriesShowing = false
    @State var storyIndex = 0

    // MARK: - Основное представление
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .center, spacing: .spacerM) {
                ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                    StoryPreview(storyPreview: story)
                        .onTapGesture {
                            isStoriesShowing = true
                            storyIndex = index
                        }
                        .fullScreenCover(isPresented: $isStoriesShowing, onDismiss: didDismiss) {
                            StoriesView(stories: $stories, storyIndex: $storyIndex)
                        }
                }
            }
            .padding(.horizontal, .spacerL)
            .padding(.vertical, .spacerXXL)
        }
        .frame(height: 188.0)
    }
}

private extension PreviewStoriesView {
    func didDismiss() {
        isStoriesShowing = false
    }
}

#Preview {
    PreviewStoriesView(stories: .constant(Story.mockData))
}
