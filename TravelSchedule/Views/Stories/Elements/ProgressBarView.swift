import SwiftUI

struct ProgressBarView: View {
    let numberOfSections: Int
    let progress: CGFloat
    private let segmentSpacing: CGFloat = 6
    private let barHeight: CGFloat = 6

    var body: some View {
        GeometryReader { geometry in
            let totalSpacing = segmentSpacing * CGFloat(numberOfSections - 1)
            let segmentWidth = max((geometry.size.width - totalSpacing) / CGFloat(numberOfSections), 0)
            HStack(spacing: segmentSpacing) {
                ForEach(0..<numberOfSections, id: \.self) { index in
                    let progressPerSection = 1.0 / CGFloat(numberOfSections)
                    let start = CGFloat(index) * progressPerSection
                    let end = start + progressPerSection
                    let filledRatio = min(max((progress - start) / progressPerSection, 0), 1)

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: segmentSpacing)
                            .frame(width: segmentWidth, height: barHeight)
                            .foregroundStyle(Color.ypWhite)

                        Rectangle()
                            .frame(width: filledRatio * segmentWidth, height: barHeight)
                            .foregroundStyle(Color.ypBlue)
                    }
                }
            }
        }
        .frame(height: barHeight)
    }
}

#Preview {
    ProgressBarView(numberOfSections: 5, progress: 0.5)
        .background(Color.ypRed.opacity(0.5))
}
