import SVGKit
import SwiftUI

struct ThreadCarrierView: View {
    let route: Thread
    let carrier: Carrier
    @Binding var carrierIcon: Image

    private var connectionInValue: String { "С пересадкой в \(route.connectionStation)" }

    var body: some View {
        HStack(spacing: .S) {
            iconView
            VStack(alignment: .leading) {
                carrierTitleView
                if !route.isDirect {
                    connectionInfoView
                }
            }
            Spacer()
            departureDateView
        }
        .padding(.top, .M)
        .padding(.horizontal, .M)
    }
}

extension ThreadCarrierView {
    fileprivate var iconView: some View {
        carrierIcon
            .frame(width: 38.0, height: 38.0)
    }

    fileprivate var carrierTitleView: some View {
        Text(carrier.title)
            .font(.regMedium)
            .foregroundStyle(Color.ypBlack)
    }

    fileprivate var connectionInfoView: some View {
        Text(connectionInValue)
            .font(.regSmall)
            .foregroundStyle(Color.ypRed)
    }

    fileprivate var departureDateView: some View {
        Text(route.date.getLocalizedShortDate)
            .font(.regSmall)
            .foregroundStyle(Color.ypBlack)
    }

    fileprivate var placeholderImageView: some View {
        Image(systemName: carrier.placeholder)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 38.0 / 1.5, height: 38.0 / 1.5)
            .foregroundStyle(Color.ypBlackDuo)
    }
}

#Preview {
    ThreadCarrierView(
        route: Thread.mockData[0],
        carrier: Carrier.mockData[0],
        carrierIcon: .constant(Image(systemName: "cablecar"))
    )
    .background(Color.ypLightGray)
}
