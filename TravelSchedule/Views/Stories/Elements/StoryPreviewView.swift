import SwiftUI

struct StoryPreviewView: View {
    private let titleLineLimit = 3
    var storyPreview: Story

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            previewImage
            title
            border
        }
        .padding(.zero)
        .frame(width: 92.0, height: 150.0)
        .contentShape(RoundedRectangle(cornerRadius: .L))
    }
}

private extension StoryPreviewView {
    var previewImage: some View {
        Image(storyPreview.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 92.0, height: 150.0)
            .clipShape(RoundedRectangle(cornerRadius: .L))
            .opacity(storyPreview.isShowed ? .halfOpacity : .fullOpacity)
    }

    var title: some View {
        Text(storyPreview.title)
            .foregroundColor(Color.ypWhite)
            .font(.regSmall)
            .padding(.horizontal, .S)
            .padding(.bottom, .M)
            .lineLimit(titleLineLimit)
    }

    var border: some View {
        RoundedRectangle(cornerRadius: .L)
            .strokeBorder(
                Color.ypBlue,
                lineWidth: storyPreview.isShowed ? .zero : .XS
            )
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
