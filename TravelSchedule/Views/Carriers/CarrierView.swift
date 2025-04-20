import SwiftUI

struct CarrierView: View {
    @State var carrier: Carrier
    var imageDownloader: ImageDownloader
    @Environment(\.openURL) private var openURL

    private enum Constants {
        static let title: String = "Информация о перевозчике"
        static let imageHeight: CGFloat = 104
        static let cornerRadius: CGFloat = .XXL
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .L) {
            logoView
            headerView
            contactRow(.email, info: carrier.email)
            contactRow(.phone, info: carrier.phone)
            contactRow(.contacts, info: carrier.contacts)
            Spacer()
        }
        .padding(.horizontal, .L)
        .setCustomNavigationBar(title: Constants.title)
    }
}

private extension CarrierView {
    enum ContactType {
        case email, phone, contacts

        var title: String {
            switch self {
                case .email:    return "E-mail"
                case .phone:    return "Телефон"
                case .contacts: return "Контакты"
            }
        }

        var scheme: String? {
            switch self {
                case .email:    return "mailto:"
                case .phone:    return "tel:"
                case .contacts: return nil
            }
        }
    }

    var logoView: some View {
        AsyncImage(url: URL(string: carrier.logoUrl)) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            Image(systemName: carrier.placeholder)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: Constants.imageHeight / 2)
                .padding(.vertical, Constants.imageHeight / 4)
                .foregroundStyle(Color.ypBlackDuo)
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.imageHeight)
        .background(Color.ypWhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    var headerView: some View {
        Text(carrier.title)
            .font(.boldMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, .L)
            .padding(.bottom, .S)
    }

    @ViewBuilder
    func contactRow(_ type: ContactType, info: String) -> some View {
        if !info.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text(type.title)
                    .font(.regMedium)
                    .foregroundStyle(Color.ypBlackDuo)
                if let scheme = type.scheme, let url = URL(string: scheme + info) {
                    Button { openURL(url) } label: {
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
