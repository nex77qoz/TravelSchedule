import Foundation

actor StationsDownloader {
    private var cacheStorage: [Components.Schemas.Settlements] = []
    private let networkServiceInstance: NetworkService

    init(networkServiceInstance: NetworkService) {
        self.networkServiceInstance = networkServiceInstance
    }

    func fetchData() async throws -> [Components.Schemas.Settlements] {
        if !cacheStorage.isEmpty { return cacheStorage }
        let listService = StationsListService(
            client: networkServiceInstance.clientInstance
        )
        let listResponse = try await listService.getStationsList()
        guard let countries = listResponse.countries else { throw ErrorType.serverError }
        countries.forEach {
            if $0.title == "Украина" { return }
            $0.regions?.forEach {
                $0.settlements?.forEach { settlement in
                    cacheStorage.append(settlement)
                }
            }
        }
        return cacheStorage
    }
}
