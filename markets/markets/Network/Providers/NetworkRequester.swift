import Foundation

protocol NetworkRequester {
    func request(
        url: String,
        method: NetworkMethod,
        parameters: [String: Any]?,
        headers: [String: String]?
    ) async throws -> Data
}
