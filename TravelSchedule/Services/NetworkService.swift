import Foundation
import OpenAPIURLSession


actor NetworkService: Sendable {
    let serverURL: URL
    let clientInstance: Client

    init() {
        do {
            serverURL = try Servers.server1()
        } catch {
            preconditionFailure("Не удалось получить server URL")
        }
        self.clientInstance = Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: APIKeys.apiKey)]
        )
    }
}
