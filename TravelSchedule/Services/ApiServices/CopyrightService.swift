import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.CopyrightObject

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> Copyright
}

actor CopyrightService: CopyrightServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getCopyright() async throws -> Copyright {
        let copyrightResult = try await clientInstance.getCopyright(query: .init())
        return try copyrightResult.ok.body.json
    }
}
