import Foundation

// Типы ошибок, которые могут возникнуть в приложении.
enum ErrorType: Int, CaseIterable {
    // Ошибка сервера.
    case serverError = 0
    // Ошибка подключения к интернету.
    case connectionError

    // Описание ошибки для отображения пользователю.
    var description: String {
        switch self {
        case .serverError: return String(localized: "Ошибка сервера")
        case .connectionError: return String(localized: "Нет интернета")
        }
    }

    // Имя изображения, связанного с ошибкой.
    var imageName: String {
        switch self {
        case .serverError: return "serverError"
        case .connectionError: return "noInternet"
        }
    }
}
