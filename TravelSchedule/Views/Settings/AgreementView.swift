import SwiftUI


struct AgreementView: View {
    let darkMode: Bool
    private let title = "Пользовательское соглашение"
    private let urlString = "https://yandex.ru/legal/practicum_offer"

    var body: some View {
        if let url = URL(string: urlString) {
            WebView(url: url, darkMode: darkMode)
                .ignoresSafeArea(.all, edges: .bottom)
                .setCustomNavigationBar(title: title)
        } else {
            Text("Ошибка: Неверный URL")
        }
    }
}

#Preview {
    NavigationStack {
        AgreementView(darkMode: false)
    }
}
