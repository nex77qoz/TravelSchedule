import OpenAPIRuntime
import Foundation
import HTTPTypes

struct HeaderService {
    private let authHeader: String

    init(authHeader: String) {
        self.authHeader = authHeader
    }
}

extension HeaderService: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request
        modifiedRequest.headerFields[.authorization] = authHeader
        return try await next(modifiedRequest, body, baseURL)
    }
}
