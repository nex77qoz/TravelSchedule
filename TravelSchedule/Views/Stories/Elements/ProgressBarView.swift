import SwiftUI

struct ProgressBarView: View {
    let numberOfSections: Int
    let progress: CGFloat
    private let backgroundColor = Color.ypWhite
    private let accentColor = Color.ypBlue

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(backgroundColor)
                    .frame(width: geometry.size.width)

                Rectangle()
                    .foregroundStyle(accentColor)
                    .frame(width: min(progress * geometry.size.width, geometry.size.width))
            }
            .frame(height: 6.0)
            .mask {
                MaskView(numberOfSections: numberOfSections, backgroundColor: backgroundColor)
            }
        }
    }
}

private struct MaskView: View {
    let numberOfSections: Int
    let backgroundColor: Color

    var body: some View {
        HStack(spacing: 6.0) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView(backgroundColor: backgroundColor)
            }
        }
    }
}

private struct MaskFragmentView: View {
    let backgroundColor: Color
    var body: some View {
        RoundedRectangle(cornerRadius: .S)
            .frame(height: 6.0)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(backgroundColor)
    }
}

#Preview {
    ProgressBarView(numberOfSections: 5, progress: 0.5)
        .background(
            Color.ypRed.opacity(0.5)
        )
}
