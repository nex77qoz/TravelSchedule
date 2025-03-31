import SwiftUI

struct StorySlideView: View {
    // MARK: - Константы
    private enum TextLimits {
        static let heading = 2
        static let details = 3
    }

    // MARK: - Свойства
    var slide: StoryPage

    // MARK: - Основное представление
    var body: some View {
        Color.ypBlack
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    Image(slide.imageName)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 40.0))
                        .padding(.top, .spacerXS)
                        .padding(.horizontal, .zero)

                    VStack(alignment: .leading, spacing: .spacerM) {
                        Spacer()

                        Text(slide.heading)
                            .font(.boldLarge)
                            .lineLimit(TextLimits.heading)

                        Text(slide.details)
                            .font(.regLarge)
                            .lineLimit(TextLimits.details)
                    }
                    .foregroundStyle(Color.ypWhite)
                    .padding(.horizontal, .spacerM)
                    .padding(.bottom, 40.0)
                }
                .padding(.bottom, .spacerL)
            }
    }
}

#Preview {
    StorySlideView(slide: StoryPage.mockData1[0])
}
