import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Double) async throws -> NearestStations
}

actor NearestStationsService: NearestStationsServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getNearestStations(lat: Double, lng: Double, distance: Double) async throws -> NearestStations {
        let stationsResult = try await clientInstance.getNearestStations(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try stationsResult.ok.body.json
    }
}
