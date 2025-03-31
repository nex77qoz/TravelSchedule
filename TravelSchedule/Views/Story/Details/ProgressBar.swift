import SwiftUI

struct SegmentedProgressBar: View {
    // MARK: - Константы
    let numberOfSections: Int
    let progress: CGFloat
    private let trackColor = Color.ypWhite
    private let fillColor = Color.ypBlue

    // MARK: - Основное представление
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(trackColor)
                    .frame(width: geometry.size.width)

                Rectangle()
                    .foregroundStyle(fillColor)
                    .frame(width: min(progress * geometry.size.width, geometry.size.width))
            }
            .frame(height: .progressBar)
            .mask {
                SegmentedMaskView(numberOfSections: numberOfSections, trackColor: trackColor)
            }
        }
    }
}

// MARK: - Приватные структуры
private struct SegmentedMaskView: View {
    let numberOfSections: Int
    let trackColor: Color

    var body: some View {
        HStack(spacing: .progressBar) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                SegmentFragmentView(trackColor: trackColor)
            }
        }
    }
}

private struct SegmentFragmentView: View {
    let trackColor: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 4.0)
            .frame(height: .progressBar)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(trackColor)
    }
}

#Preview {
    SegmentedProgressBar(numberOfSections: 5, progress: 0.5)
        .background(
            Color.ypRed.opacity(0.5)
        )
}
