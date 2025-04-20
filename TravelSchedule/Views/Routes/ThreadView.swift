import SwiftUI

struct ThreadView: View {
    let route: Thread
    let carrier: Carrier
    var imageDownloader: ImageDownloader
    @State private (set) var carrierIcon = Image(systemName: "nosign.app")

    var body: some View {
        VStack(spacing: 0) {
            ThreadCarrierView(route: route, carrier: carrier, carrierIcon: $carrierIcon)
            timelineView
        }
        .background(Color.ypLightGray)
        .frame(maxWidth: .infinity, maxHeight: 104)
        .clipShape(RoundedRectangle(cornerRadius: .XXL))
        .task {
            let placeholderLogo = Image(systemName: carrier.placeholder)
            self.carrierIcon = carrier.logoSVGUrl.isEmpty
            ? await imageDownloader.fetchImage(from: carrier.logoUrl) ?? placeholderLogo
            : await imageDownloader.fetchSvgImage(from: carrier.logoSVGUrl) ?? placeholderLogo
        }
    }
}

private extension ThreadView {
    var timelineView: some View {
        HStack(spacing: 0) {
            timeDetailsView(field: .left, title: route.departureTime)
            Spacer()
            timeDetailsView(field: .center, title: route.durationTime)
            Spacer()
            timeDetailsView(field: .right, title: route.arrivalTime)
        }
        .background(
            lineView
        )
        .foregroundStyle(Color.ypBlack)
        .padding(.vertical, .M)
        .padding(.horizontal, .S)
        .frame(maxWidth: .infinity, maxHeight: 48.0)
    }

    var lineView: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.ypGray)
    }

    func timeDetailsView(field: FieldPosition, title: String) -> some View {
        Text(title)
            .font(field == .center ? .regSmall : .regMedium)
            .padding(.horizontal, .S)
            .background(Color.ypLightGray)
    }

    enum FieldPosition {
        case left, center, right
    }
}

#Preview {
    ThreadView(route: Thread.mockData[0], carrier: Carrier.mockData[1], imageDownloader: ImageDownloader())
}
