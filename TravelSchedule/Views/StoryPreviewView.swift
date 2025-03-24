import SwiftUI

struct StoryPreviewView: View {
    let story: Story

    var body: some View {
        ZStack {
            Image(story.previewImageName)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(story.isRead ? 0.5 : 1)

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.ypBlue, lineWidth: story.isRead ? 0 : 4)
        }
        .frame(width: 92, height: 140)
    }
}
