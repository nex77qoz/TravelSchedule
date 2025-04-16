import Foundation

extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url, delegate: nil)
    }
}
