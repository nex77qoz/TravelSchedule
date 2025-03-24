import SwiftUI

// Расширение для установки кастомных модификаторов на View
extension View {
    
    // Устанавливает кастомную кнопку "Назад" для навигации
    func setCustomNavBackButton() -> some View {
        modifier(SetCustomNavBackButton())
    }

    // Устанавливает кастомную навигационную панель с заголовком
    func setCustomNavigationBar(title: String = "") -> some View {
        modifier(SetCustomNavigationBar(title: title))
    }
}
