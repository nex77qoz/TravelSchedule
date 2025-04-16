import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Settlement = Components.Schemas.Settlement

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(lat: Double, lng: Double, distance: Double) async throws -> Settlement
}

actor NearestSettlementService: NearestSettlementServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getNearestSettlement(lat: Double, lng: Double, distance: Double) async throws -> Settlement {
        let settlementResult = try await clientInstance.getNearestSettlement(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try settlementResult.ok.body.json
    }
}
