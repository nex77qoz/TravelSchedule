import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Threads = Components.Schemas.ThreadObject

protocol ThreadServiceProtocol {
    func getThread(uid: String) async throws -> Threads
}

final class ThreadService: ThreadServiceProtocol {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getThread(uid: String) async throws -> Threads {
        let response = try await client.getThread(query: .init(uid: uid))
        return try response.ok.body.json
    }
}
