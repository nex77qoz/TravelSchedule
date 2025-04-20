import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Environment(\.colorScheme) private var colorScheme

    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let horizontalPadding: CGFloat = .L
        static let barHeight: CGFloat = 36
        static let iconPadding: CGFloat = .S
        static let placeholder = "Введите запрос"
    }

    var body: some View {
        HStack(spacing: 0) {
            searchIcon
            searchField
            if !searchText.isEmpty { cancelButton }
        }
        .frame(height: Constants.barHeight)
        .background(colorScheme == .light ? Color.ypLightGray : Color.ypDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

private extension SearchBarView {
    var searchIcon: some View {
        icon(Image.iconSearching)
            .foregroundStyle(searchText.isEmpty ? Color.ypGray : Color.ypBlackDuo)
    }

    var searchField: some View {
        TextField(Constants.placeholder, text: $searchText)
            .font(.regMedium)
            .foregroundStyle(Color.ypBlackDuo)
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
    }

    var cancelButton: some View {
        Button { cancelSearch() } label: {
            icon(Image.iconSearchCancel)
                .foregroundStyle(Color.ypGray)
        }
    }

    func icon(_ image: Image) -> some View {
        image
            .resizable()
            .frame(width: .iconSize, height: .iconSize)
            .padding(.horizontal, Constants.iconPadding)
    }

    func cancelSearch() {
        searchText = ""
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    VStack(spacing: .XL) {
        SearchBarView(searchText: .constant(""))
        SearchBarView(searchText: .constant("some text"))
    }
}
