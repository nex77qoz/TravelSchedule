import SwiftUI

struct ThreadCarrierView: View {
    let route: Thread
    let carrier: Carrier
    @Binding var carrierIcon: Image

    private var connectionInfo: String {
        "С пересадкой в \(route.connectionStation)"
    }

    var body: some View {
        HStack(spacing: .S) {
            iconView
            VStack(alignment: .leading, spacing: .XS) {
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

private extension ThreadCarrierView {

    var iconView: some View {
        carrierIcon
            .frame(width: .logoSize, height: .logoSize)
    }

    var carrierTitleView: some View {
        Text(carrier.title)
            .font(.regMedium)
            .foregroundStyle(Color.ypBlack)
    }

    var connectionInfoView: some View {
        Text(connectionInfo)
            .font(.regSmall)
            .foregroundStyle(Color.ypRed)
    }

    var departureDateView: some View {
        Text(route.date.getLocalizedShortDate)
            .font(.regSmall)
            .foregroundStyle(Color.ypBlack)
    }

    var placeholderImageView: some View {
        Image(systemName: carrier.placeholder)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: .logoSize / 1.5,
                   height: .logoSize / 1.5)
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
