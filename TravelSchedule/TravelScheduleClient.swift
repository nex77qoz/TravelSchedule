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
    private let baseURL = "https://api.rasp.yandex.net/v3.0"
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any] = [:],
        completion: @escaping (Result<T, TravelScheduleError>) -> Void
    ) {
        var components = URLComponents(string: baseURL + endpoint)
        
        var queryItems = [URLQueryItem(name: "apikey", value: apiKey)]
        parameters.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("📡 Сетевая ошибка для \(endpoint): \(error)")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("📡 Неверный ответ для \(endpoint)")
                completion(.failure(.custom("Неверный ответ")))
                return
            }
            
            print("📡 Ответ для \(endpoint): Статус \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    print("📡 Нет данных для \(endpoint)")
                    completion(.failure(.noData))
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    let previewLength = 300
                    let truncated = jsonString.count > previewLength ?
                        "\(jsonString.prefix(previewLength))..." : jsonString
                    print("📦 JSON ответа: \(truncated)")
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("⚠️ Ошибка декодирования: \(error)")
                    completion(.failure(.decodingError(error)))
                }
                
            case 401:
                print("📡 Неавторизован для \(endpoint)")
                completion(.failure(.unauthorized))
            default:
                print("📡 Ошибка сервера \(httpResponse.statusCode) для \(endpoint)")
                completion(.failure(.serverError(httpResponse.statusCode)))
            }
        }
        
        task.resume()
    }
}
