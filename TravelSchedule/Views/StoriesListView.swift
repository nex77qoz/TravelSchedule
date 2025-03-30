import SwiftUI

struct StoriesListView: View {
    @Binding var stories: [Story]

    // Один гибкий ряд для горизонтальной сетки
    private let rows = [GridItem(.flexible())]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .center, spacing: 12) {
                ForEach(stories) { story in
                    StoryPreviewView(story: story)
                }
            }
            .padding(.horizontal, .spacerL)
            .padding(.vertical, .spacerXXL)
        }
        .frame(height: 188)
        .background(Color.ypWhiteDuo)
    }
}

#Preview {
    StoriesListView(stories: .constant(Story.sampleData))
}
