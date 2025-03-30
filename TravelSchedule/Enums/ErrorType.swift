import Foundation

enum ErrorType: Int, CaseIterable {
    case serverError = 0
    case connectionError

    var description: String {
        switch self {
        case .serverError: return String(localized: "Ошибка сервера")
        case .connectionError: return String(localized: "Нет интернета")
        }
    }

    var imageName: String {
        switch self {
        case .serverError: return "serverError"
        case .connectionError: return "noInternet"
        }
    }
}
