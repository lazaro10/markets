import Foundation
@testable import markets

struct NetworkRequestConfiguratorSpy: Equatable {
    let baseURL: NetworkBaseURL
    let path: String
    let method: NetworkMethod
    let parameters: [String: Any]
    let hearders: [String: String]

    init(from configurator: NetworkRequestConfigurator) {
        self.baseURL = configurator.baseURL
        self.path = configurator.path
        self.method = configurator.method
        self.parameters = configurator.parameters
        self.hearders = configurator.hearders
    }

    static func == (lhs: NetworkRequestConfiguratorSpy, rhs: NetworkRequestConfiguratorSpy) -> Bool {
        lhs.baseURL == rhs.baseURL &&
        lhs.path == rhs.path &&
        lhs.method == rhs.method &&
        NSDictionary(dictionary: lhs.parameters).isEqual(to: rhs.parameters) &&
        lhs.hearders == rhs.hearders
    }
}
