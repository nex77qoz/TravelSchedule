import SwiftUI

struct StoryPreviewView: View {
    var storyPreview: Story

    var body: some View {
        Image(storyPreview.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 92, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: .L))
            .opacity(storyPreview.isShowed ? .halfOpacity : .fullOpacity)
            .overlay(
                RoundedRectangle(cornerRadius: .L)
                    .strokeBorder(
                        Color.ypBlue,
                        lineWidth: storyPreview.isShowed ? 0 : .XS
                    )
            )
            .overlay(
                Text(storyPreview.title)
                    .font(.regSmall)
                    .foregroundColor(.ypWhite)
                    .lineLimit(3)
                    .padding(.horizontal, .S)
                    .padding(.bottom, .M),
                alignment: .bottomLeading
            )
            .frame(width: 92, height: 150)
            .contentShape(RoundedRectangle(cornerRadius: .L))
    }
}

#Preview {
    let newStory = Story.mockData[0]
    var showedStory = Story.mockData[0]
    showedStory.isShowed = true
    return HStack {
        StoryPreviewView(storyPreview: newStory)
        StoryPreviewView(storyPreview: showedStory)
    }
}
