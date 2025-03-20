import Foundation

enum TravelScheduleError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case noData
    case unauthorized
    case custom(String)
}

class TravelScheduleClient {
    private let apiKey: String
    private let baseURL = "https://api.rasp.yandex.net/v3.0"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: Any],
        completion: @escaping (Result<T, TravelScheduleError>) -> Void
    ) {
        var allParameters = parameters
        allParameters["apikey"] = apiKey

        guard var components = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var queryItems = [URLQueryItem]()
        for (key, value) in allParameters {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Формируем URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let decodeError {
                completion(.failure(.decodingError(decodeError)))
            }
        }
        
        task.resume()
    }
}
