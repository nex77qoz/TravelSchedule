import OpenAPIURLSession
import Foundation

struct APIClient {
    let client: Client
    let apiKey: String

    init(apiKey: String, serverURL: URL = try! Servers.Server1.url()) {
        self.client = Client(
            serverURL: serverURL,
            transport: URLSessionTransport()
        )
        self.apiKey = apiKey
    }
}
