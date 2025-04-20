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
        clientInstance = Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: APIKeys.apiKey)]
        )
    }

    func fetchSettlements() async throws -> [Components.Schemas.Settlements] {
        let service = StationsListService(client: clientInstance)
        let list = try await service.getStationsList()
        return list.countries?
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] } ?? []
    }

    func searchSegments(from: Station, to: Station, date: String) async throws -> [Components.Schemas.Segment] {
        let service = SearchService(client: clientInstance)
        let response = try await service.getSearches(from: from.code, to: to.code, with: true)
        return response.segments ?? []
    }

    func fetchCopyright() async throws -> Copyright {
        let service = CopyrightService(client: clientInstance)
        return try await service.getCopyright()
    }
}
