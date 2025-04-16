import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Carriers = Components.Schemas.Carriers

protocol CarriersServiceProtocol {
    func getCarriers(code: Int, system: Components.Parameters.systemParam?) async throws -> Carriers
    func getCarriers(code: Int) async throws -> Carriers
}

actor CarriersService: CarriersServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getCarriers(code: Int) async throws -> Carriers {
        let carrierResult = try await clientInstance.getCarrier(
            query: .init(code: code)
        )
        return try carrierResult.ok.body.json
    }

    func getCarriers(code: Int, system: Components.Parameters.systemParam?) async throws -> Carriers {
        let carrierResult = try await clientInstance.getCarrier(
            query: .init(code: code, system: system)
        )
        return try carrierResult.ok.body.json
    }
}
