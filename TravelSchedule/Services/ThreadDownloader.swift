import Foundation

actor ThreadDownloader {
    private let networkServiceInstance: NetworkService

    init(networkServiceInstance: NetworkService) {
        self.networkServiceInstance = networkServiceInstance
    }

    func fetchData(from departure: Station, to arrival: Station) async throws -> [Components.Schemas.Segment] {
        let searchService = SearchService(client: networkServiceInstance.clientInstance)
        let searchesResult = try await searchService.getSearches(from: departure.code, to: arrival.code, with: true)
        guard let segments = searchesResult.segments else { throw ErrorType.serverError }
        return segments
    }
}
