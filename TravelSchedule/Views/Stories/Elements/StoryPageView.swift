import SwiftUI

struct StoryPageView: View {
    var model: StoryPage

    var body: some View {
        Color.ypBlack
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    fullImage
                    information
                }
                .padding(.bottom, .L)
            }
    }
}

private extension StoryPageView {
    var fullImage: some View {
        Image(model.imageName)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 40.0))
            .padding(.top, .S)
            .padding(.horizontal, .zero)
    }

    var information: some View {
        VStack(alignment: .leading, spacing: .M) {
            Spacer()
            title
            description
        }
        .foregroundStyle(Color.ypWhite)
        .padding(.horizontal, .M)
        .padding(.bottom, 40.0)
    }

    var title: some View {
        Text(model.title)
            .font(.boldLarge)
            .lineLimit(LineLimits.title)
    }

    var description: some View {
        Text(model.description)
            .font(.regLarge)
            .lineLimit(LineLimits.description)
    }
}

private extension StoryPageView {
    enum LineLimits {
        static let title = 2
        static let description = 3
    }
}

#Preview {
    StoryPageView(model: StoryPage.mockData1[0])
}
