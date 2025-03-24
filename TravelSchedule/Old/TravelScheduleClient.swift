//import Foundation
//import OSLog
//
//enum TravelScheduleError: Error {
//    case invalidURL
//    case networkError(Error)
//    case decodingError(Error)
//    case serverError(Int)
//    case noData
//    case unauthorized
//    case custom(String)
//}
//
//class TravelScheduleClient {
//    let apiKey: String
//    private let baseURL = "https://api.rasp.yandex.net/v3.0"
//    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "TravelSchedule", category: "Network")
//    
//    static let decoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        return decoder
//    }()
//    
//    init(apiKey: String) {
//        self.apiKey = apiKey
//        logger.debug("Initialized with API key: \(apiKey)")
//    }
//    
//    private func buildURL(endpoint: String, parameters: [String: Any]) -> URL? {
//        var allParameters = parameters
//        allParameters["apikey"] = apiKey
//        
//        guard var components = URLComponents(string: baseURL + endpoint) else {
//            return nil
//        }
//        components.queryItems = allParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//        return components.url
//    }
//    
//    func request<T: Decodable>(endpoint: String, parameters: [String: Any]) async -> Result<T, TravelScheduleError> {
//        guard let url = buildURL(endpoint: endpoint, parameters: parameters) else {
//            return .failure(.invalidURL)
//        }
//        logger.debug("Request URL: \(url.absoluteString)")
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard let httpResponse = response as? HTTPURLResponse else {
//                return .failure(.noData)
//            }
//            guard (200..<300).contains(httpResponse.statusCode) else {
//                if httpResponse.statusCode == 401 {
//                    return .failure(.unauthorized)
//                }
//                return .failure(.serverError(httpResponse.statusCode))
//            }
//            let decoded = try TravelScheduleClient.decoder.decode(T.self, from: data)
//            return .success(decoded)
//        } catch {
//            if let error = error as? DecodingError {
//                return .failure(.decodingError(error))
//            }
//            return .failure(.networkError(error))
//        }
//    }
//    
//}
