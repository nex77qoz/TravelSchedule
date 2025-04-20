import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Schedules = Components.Schemas.Schedules

protocol SchedulesServiceProtocol {
    func getSchedules(station: String, date: String?) async throws -> Schedules
}

actor SchedulesService: SchedulesServiceProtocol, Sendable {
    private let clientInstance: Client

    init(client: Client) {
        self.clientInstance = client
    }

    func getSchedules(station: String, date: String?) async throws -> Schedules {
        let schedulesResult = try await clientInstance.getSchedule(query: .init(station: station, date: date))
        return try schedulesResult.ok.body.json
    }
}
