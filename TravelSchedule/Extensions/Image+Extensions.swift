import SwiftUI

extension Image {
    // Иконки для табов
    static let iconTabSearch = Image("schedule").renderingMode(.template)
    static let iconTabSettings = Image("settings").renderingMode(.template)

    // Иконки для поиска
    static let iconSearchSwap = Image(systemName: "arrow.2.squarepath")
    static let iconSearching = Image(systemName: "magnifyingglass")
    static let iconSearchCancel = Image(systemName: "xmark.circle.fill")

    // Навигационные стрелки
    static let iconBackward = Image(systemName: "chevron.backward")
    static let iconForward = Image(systemName: "chevron.forward")
    static let iconArrow = Image(systemName: "arrow.forward")

    // Чекбоксы и радиокнопки
    static let iconCheckboxOn = Image(systemName: "checkmark.square.fill")
    static let iconCheckboxOff = Image(systemName: "square")
    static let iconRadioOn = Image(systemName: "largecircle.fill.circle")
    static let iconRadioOff = Image(systemName: "circle")

    // Картинка для отображения ошибки сервера
    static let imageServerError = Image("xmark.circle.fill")
    
    // Прочие иконки
    static let cancel = Image(systemName: "xmark.circle.fill").renderingMode(.template)
    static let marker = Image(systemName: "circle.fill")
}
