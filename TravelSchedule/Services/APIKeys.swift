import Foundation

enum APIKeys {
    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["YANDEX_API_KEY"] as? String
        else {
            fatalError("YANDEX_API_KEY не найден в APIKeys.plist")
        }
        return key
    }
}
