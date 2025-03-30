import SwiftUI

struct StoryPreview: View {
    // MARK: - Константы
    private let titleLineLimit = 3

    // MARK: - Свойства
    var storyPreview: Story

    // MARK: - Основное представление
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(storyPreview.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 92.0, height: 140.0)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .opacity(storyPreview.isShowed ? 0.5 : 1.0)

            Text(storyPreview.title)
                .foregroundColor(Color.ypWhite)
                .font(.regSmall)
                .padding(.horizontal, .spacerS)
                .padding(.bottom, .spacerM)
                .lineLimit(titleLineLimit)

            RoundedRectangle(cornerRadius: 20.0)
                .strokeBorder(
                    Color.ypBlue,
                    lineWidth: storyPreview.isShowed ? .zero : 4.0
                )
        }
        .padding(.zero)
        .frame(width: 92.0, height: 140.0)
        .contentShape(RoundedRectangle(cornerRadius: 20.0))
    }
}

#Preview {
    let newStory = Story.mockData[0]
    var showedStory = Story.mockData[0]
    showedStory.isShowed = true
    return HStack {
        StoryPreview(storyPreview: newStory)
        StoryPreview(storyPreview: showedStory)
    }
}
