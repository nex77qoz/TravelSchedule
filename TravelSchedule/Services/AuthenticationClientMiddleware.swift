import OpenAPIRuntime
import Foundation
import HTTPTypes

struct AuthenticationMiddleware {
    private let authToken: String

    init(authorizationHeaderFieldValue authToken: String) {
        self.authToken = authToken
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var authenticatedRequest = request
        authenticatedRequest.headerFields[.authorization] = authToken
        return try await next(authenticatedRequest, body, baseURL)
    }
}
