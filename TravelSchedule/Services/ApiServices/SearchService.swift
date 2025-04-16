import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Searches = Components.Schemas.SearchObject

protocol SearchServiceProtocol {
    func getSearches(from: String, to: String, with transfers: Bool) async throws -> Searches
}

actor SearchService: SearchServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getSearches(from fromStation: String, to toStation: String, with transfers: Bool) async throws -> Searches {
        let date = String(Date.now.ISO8601Format().prefix(10))
        let searchesResult = try await clientInstance.getSearches(
            query: .init(from: fromStation, to: toStation, date: date, transfers: transfers)
        )
        return try searchesResult.ok.body.json
    }
}
