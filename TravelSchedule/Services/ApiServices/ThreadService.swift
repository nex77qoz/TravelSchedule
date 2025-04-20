import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Threads = Components.Schemas.ThreadObject

protocol ThreadServiceProtocol {
    func getThread(uid: String) async throws -> Threads
}

actor ThreadService: ThreadServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getThread(uid: String) async throws -> Threads {
        let threadResult = try await clientInstance.getThread(query: .init(uid: uid))
        return try threadResult.ok.body.json
    }
}
