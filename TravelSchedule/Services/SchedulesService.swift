import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Schedules = Components.Schemas.Schedules

protocol SchedulesServiceProtocol {
    func getSchedules(station: String, date: String?) async throws -> Schedules
}

final class SchedulesService: SchedulesServiceProtocol {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getSchedules(station: String, date: String?) async throws -> Schedules {
        let response = try await client.getSchedule(query: .init(station: station, date: date))
        return try response.ok.body.json
    }
}
