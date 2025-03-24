import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    @Environment(\.colorScheme) var colorScheme  // Актуальная цветовая схема (светлая/тёмная)

    var placeholder = "Введите запрос"

    var body: some View {
        HStack(spacing: 0) {
            // Иконка "поиск"
            Image.iconSearching
                .resizable()
                .frame(width: .iconSize, height: .iconSize)
                .padding(.horizontal, .spacerS)
                .foregroundColor(searchText.isEmpty ? .ypGray : .ypBlackDuo)

            // Текстовое поле ввода
            TextField(placeholder, text: $searchText)
                .font(.regMedium)
                .foregroundColor(.ypBlackDuo)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)

            // Кнопка очистки строки поиска (появляется при вводе)
            if !searchText.isEmpty {
                Button {
                    searchText = String()
                    // Закрываем клавиатуру
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                } label: {
                    Image.iconSearchCancel
                        .resizable()
                        .frame(width: .iconSize, height: .iconSize)
                        .padding(.horizontal, .spacerS)
                        .foregroundColor(.ypGray)
                }
            }
        }
        .frame(height: 36)
        .background(colorScheme == .light ? .ypLightGray : .ypDarkGray) // Цвет зависит от темы
        .cornerRadius(10)
        .padding(.horizontal, .spacerL)
    }
}
