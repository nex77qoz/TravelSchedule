import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Ошибка")
                .font(.title)
                .bold()
            Text(errorMessage)
                .multilineTextAlignment(.center)
            Button("Закрыть") {
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
