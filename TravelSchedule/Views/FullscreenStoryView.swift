import SwiftUI

struct FullscreenStoryView: View {
    @State private var mutableStories: [Story]
    @Binding var currentIndex: Int
    @Environment(\.dismiss) var dismiss
    
    init(stories: Binding<[Story]>, currentIndex: Binding<Int>) {
        self._mutableStories = State(initialValue: stories.wrappedValue)
        self._currentIndex = currentIndex
        self._stories = stories
    }
    
    private let _stories: Binding<[Story]>
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentIndex) {
                ForEach(0..<mutableStories.count, id: \.self) { index in
                    StoryPagesView(story: mutableStories[index])
                        .tag(index)
                        .onAppear {
                            if !mutableStories[index].isRead {
                                mutableStories[index].isRead = true
                                _stories.wrappedValue[index].isRead = true
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onChange(of: currentIndex) { _ in }
            .ignoresSafeArea()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.top, 60)
            .padding(.trailing, 20)
        }
        .background(Color.black)
    }
}

private struct StoryPagesView: View {
    let story: Story
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(story.pageImageNames.enumerated()), id: \.offset) { index, imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

#Preview {
    FullscreenStoryView(
        stories: .constant(Story.sampleData),
        currentIndex: .constant(0)
    )
}
