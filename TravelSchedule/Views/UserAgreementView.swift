import SwiftUI

struct AgreementView: View {
    let darkMode: Bool

    @State private var simulateConnectionError = false
    @State private var simulateServerError = false
    @State private var isContinueTapped = false

    private let urlString = "https://yandex.ru/legal/practicum_offer"

    var body: some View {
        Group {
            if isContinueTapped {
                contentView()
            } else {
                setupView()
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    @ViewBuilder
    private func setupView() -> some View {
        VStack(spacing: 24) {
            Toggle("Смоделировать ошибку подключения", isOn: $simulateConnectionError)
            Toggle("Смоделировать ошибку сервера", isOn: $simulateServerError)

            Button("Продолжить") {
                isContinueTapped = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private func contentView() -> some View {
        if simulateConnectionError {
            ErrorView(errorType: .connectionError)
        } else if simulateServerError {
            ErrorView(errorType: .serverError)
        } else if let url = URL(string: urlString) {
            WebView(url: url, darkMode: darkMode)
                .setCustomNavigationBar(title: "Пользовательское соглашение")
        } else {
            ErrorView(errorType: .serverError)
        }
    }
}
