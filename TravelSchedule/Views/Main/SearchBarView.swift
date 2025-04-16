import SwiftUI

struct SearchBarView: View {
    private let cornerRadius = 10.0
    private let padding = CGFloat(.L)
    private let height = 36.0
    private let iconSize = 17.0
    private let iconPadding = CGFloat(.S)
    private let placeholder = "Введите запрос"

    @Binding var searchText: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: .zero) {
            searchIcon
            searchTextField
            if !searchText.isEmpty {
                cancelButton
            }
        }
        .frame(height: height)
        .background(colorScheme == .light ? Color.ypLightGray : Color.ypDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .padding(.horizontal, padding)
    }
}

private extension SearchBarView {
    var searchIcon: some View {
        show(icon: Image.iconSearching)
            .foregroundStyle(searchText.isEmpty ? Color.ypGray : Color.ypBlackDuo)
    }

    var searchTextField: some View {
        TextField(placeholder, text: $searchText)
            .font(.regMedium)
            .foregroundStyle(Color.ypBlackDuo)
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
    }

    @MainActor
    var cancelButton: some View {
        Button {
            cancelSearching()
        } label: {
            show(icon: Image.iconSearchCancel)
                .foregroundStyle(Color.ypGray)
        }
    }
}

private extension SearchBarView {
    func show(icon: Image) -> some View {
        icon
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .padding(.horizontal, iconPadding)
    }

    @MainActor
    func cancelSearching() {
        searchText = String()
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    VStack {
        VStack {
            SearchBarView(searchText: .constant(""))
            SearchBarView(searchText: .constant("some text"))
        }
        .environment(\.colorScheme, .light)
        .padding(.vertical, 44)

        VStack {
            SearchBarView(searchText: .constant(""))
            SearchBarView(searchText: .constant("some text"))
        }
        .environment(\.colorScheme, .dark)
    }
}
