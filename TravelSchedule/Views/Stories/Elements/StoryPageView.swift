import SwiftUI

struct StoryPageView: View {
    var model: StoryPage

    var body: some View {
        ZStack {
            Color.ypBlack
                .ignoresSafeArea()

            Image(model.imageName)
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.top, .S)

            VStack(alignment: .leading, spacing: .M) {
                Spacer()

                Text(model.title)
                    .font(.boldLarge)
                    .foregroundColor(.ypWhite)
                    .lineLimit(2)

                Text(model.description)
                    .font(.regLarge)
                    .foregroundColor(.ypWhite)
                    .lineLimit(3)
            }
            .padding(.horizontal, .M)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    StoryPageView(model: StoryPage.mockData1[0])
}
