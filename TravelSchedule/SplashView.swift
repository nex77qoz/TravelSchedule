import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black // Фоновый цвет, чтобы не было пустых областей
                .edgesIgnoringSafeArea(.all)
            
            Image("splash")
                .resizable()
                .scaledToFit() // Показывает всё изображение целиком
                .edgesIgnoringSafeArea(.all)
        }
    }
}
