import SwiftUI

struct CarrierView: View {
    @State var carrier: Carrier
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(carrier.logoName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 104)
                .background(.ypWhite)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            Text("ОАО «\(carrier.title)»")
                .font(.boldMedium)
                .frame(maxWidth: .infinity, maxHeight: 29, alignment: .leading)
                .padding(.vertical, .spacerL)
            VStack(alignment: .leading, spacing: 0) {
                Text("E-mail")
                    .font(.regMedium)
                    .foregroundStyle(.ypBlackDuo)
                Button {
                    guard let url = URL(string: "mailto:" + carrier.email) else { return }
                    openURL(url)
                } label: {
                    Text("\(carrier.email)")
                        .font(.regSmall)
                    .foregroundStyle(.ypBlue)
                }
            }
            .frame(height: 60)
            VStack(alignment: .leading, spacing: 0) {
                Text("Телефон")
                    .font(.regMedium)
                    .foregroundStyle(.ypBlackDuo)
                Button {
                    guard let url = URL(string: "tel:" + carrier.phone) else { return }
                    openURL(url)
                } label: {
                    Text("\(carrier.phone)")
                        .font(.regSmall)
                    .foregroundStyle(.ypBlue)
                }
            }
            .frame(height: 60)
            Spacer()
        }
        .padding(.horizontal, .spacerL)
        .setCustomNavigationBar(title: "Информация о перевозчике")
    }
}

#Preview {
    NavigationStack {
        CarrierView(carrier: Carrier.sampleData[0])
    }
}
