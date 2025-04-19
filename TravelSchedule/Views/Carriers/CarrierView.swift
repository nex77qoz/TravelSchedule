import SwiftUI

struct CarrierView: View {
    private let title = "Информация о перевозчике"
    @State var carrier: Carrier
    var imageDownloader: ImageDownloader
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: .L) {
            imageView
            titleView
            contactRow(type: .email, info: carrier.email)
            contactRow(type: .phone, info: carrier.phone)
            contactRow(type: .contacts, info: carrier.contacts)
            Spacer()
        }
        .padding(.horizontal, .L)
        .setCustomNavigationBar(title: title)
    }
}

private extension CarrierView {
    enum ContactType {
        case email, phone, contacts

        var title: String {
            switch self {
                case .email: "E-mail"
                case .phone: "Телефон"
                case .contacts: "Контакты"
            }
        }

        var urlScheme: String? {
            switch self {
                case .email: return "mailto:"
                case .phone: return "tel:"
                case .contacts: return nil
            }
        }
    }

    var imageView: some View {
        AsyncImage(url: URL(string: carrier.logoUrl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            placeholderImageView
        }
        .frame(maxWidth: .infinity, maxHeight: 104.0)
        .background(Color.ypWhite)
        .clipShape(RoundedRectangle(cornerRadius: .XXL))
    }

    var placeholderImageView: some View {
        Image(systemName: carrier.placeholder)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 104.0 / 2)
            .padding(.vertical, 104.0 / 4)
    }

    var titleView: some View {
        Text(carrier.title)
            .font(.boldMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, .L)
            .padding(.bottom, .S)
    }

    @ViewBuilder
    func contactRow(type: ContactType, info: String) -> some View {
        if !info.isEmpty {
            VStack(alignment: .leading, spacing: .zero) {
                Text(type.title)
                    .font(.regMedium)
                    .foregroundStyle(Color.ypBlackDuo)

                if let urlScheme = type.urlScheme, let url = URL(string: urlScheme + info) {
                    Button {
                        openURL(url)
                    } label: {
                        Text(info)
                            .font(.regSmall)
                            .foregroundStyle(Color.ypBlackDuo)
                    }
                } else {
                    Text(info)
                        .font(.regSmall)
                        .foregroundStyle(Color.ypBlackDuo)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CarrierView(carrier: Carrier.mockData[0], imageDownloader: ImageDownloader())
    }
}
