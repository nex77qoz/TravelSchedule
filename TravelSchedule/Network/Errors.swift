import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, String?)
    case unknownError(Error)
    case unauthorized
    case notFound

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL."
        case .requestFailed(let error):
            return "Ошибка запроса: \(error.localizedDescription)"
        case .invalidResponse:
            return "Неверный ответ от сервера."
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Ошибка сервера (\(code)): \(message ?? "Неизвестная ошибка")"
        case .unknownError(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        case .unauthorized:
            return "Не авторизован. Проверьте API ключ"
        case .notFound:
            return "Ресурс не найден"
        }
    }
}
