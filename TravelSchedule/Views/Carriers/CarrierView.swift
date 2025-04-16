import SwiftUI

struct CarrierView: View {
    private let title = "Информация о перевозчике"
    @State var carrier: Carrier
    var imageDownloader: ImageDownloader
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            imageView
            titleView
            show(info: carrier.email, for: .email)
            show(info: carrier.phone, for: .phone)
            show(info: carrier.contacts, for: .contacts)
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
    }
    var carrierTitle: String { (carrier.title) }
    var emailUrl: String { "mailto:" + carrier.email }
    var phoneUrl: String { "tel:" + carrier.phone }

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
        Text(carrierTitle)
            .font(.boldMedium)
            .frame(maxWidth: .infinity, maxHeight: 29.0, alignment: .leading)
            .padding(.vertical, .L)
    }
}

private extension CarrierView {
    func show(info: String, for type: ContactType) -> some View {
        return VStack(alignment: .leading, spacing: .zero) {
            show(header: type.title)
            switch type {
                case .email: showButton(for: .email)
                case .phone: showButton(for: .phone)
                case .contacts: show(info: carrier.contacts)
            }
        }.frame(height: type == .contacts ? 60.0 * 2 : 60.0)
    }

    func show(header: String) -> some View {
        Text(header)
            .font(.regMedium)
            .foregroundStyle(Color.ypBlackDuo)
    }

    func show(info: String) -> some View {
        VStack(spacing: .zero) {
            Text(info)
                .font(.regSmall)
                .foregroundStyle(Color.ypBlackDuo)
            Spacer()
        }
    }

    func showButton(for type: ContactType) -> some View {
        Button {
            guard let url = URL(string: type == .email ? emailUrl : phoneUrl) else { return }
            openURL(url)
        } label: {
            show(info: type == .email ? carrier.email : carrier.phone)
        }
    }
}

#Preview {
    NavigationStack {
        CarrierView(carrier: Carrier.mockData[0], imageDownloader: ImageDownloader())
    }
}
