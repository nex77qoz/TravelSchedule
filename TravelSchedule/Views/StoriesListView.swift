import SwiftUI

struct StoriesListView: View {
    @Binding var stories: [Story]
    @State private var showFullscreen = false
    @State private var selectedIndex = 0

    // Один гибкий ряд для горизонтальной сетки
    private let rows = [GridItem(.flexible())]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .center, spacing: 12) {
                ForEach(0..<stories.count, id: \.self) { index in
                    StoryPreviewView(story: stories[index])
                        .onTapGesture {
                            selectedIndex = index
                            showFullscreen = true
                        }
                }
            }
            .padding(.horizontal, .spacerL)
            .padding(.vertical, .spacerXXL)
        }
        .frame(height: 188)
        .background(Color.ypWhiteDuo)
        .fullScreenCover(isPresented: $showFullscreen) {
            FullscreenStoryView(
                stories: $stories,
                currentIndex: $selectedIndex
            )
        }
    }
}

#Preview {
    StoriesListView(stories: .constant(Story.sampleData))
}
