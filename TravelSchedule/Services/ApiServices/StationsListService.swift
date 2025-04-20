import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsList = Components.Schemas.StationsList

protocol StationsListServiceProtocol {
    func getStationsList() async throws -> StationsList
}

actor StationsListService: StationsListServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getStationsList() async throws -> StationsList {
        let stationsListResult = try await clientInstance.getStationsList(.init())
        let httpBody = try stationsListResult.ok.body.html
        let data = try await Data(collecting: httpBody, upTo: 44 * 1024 * 1024)
        let stationList = try JSONDecoder().decode(StationsList.self, from: data)
        return stationList
    }
}
