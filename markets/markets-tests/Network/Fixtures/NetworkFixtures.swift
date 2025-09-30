import Foundation
@testable import markets

enum NetworkFixtures {
    struct RequestConfig: NetworkRequestConfigurator {
        var path: String { "/path" }
        var parameters: [String: Any] { ["key": "value"] }
        var hearders: [String: String] { ["Header": "Value"] }
    }

    struct Response: Codable, Equatable {
        let name: String
    }

    static func makeResponse(name: String = "a name") -> Response {
        Response(name: name)
    }
}
