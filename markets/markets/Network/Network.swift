import Foundation

protocol NetworkLogic {
    func request<T: Decodable>(
        configuration: NetworkRequestConfigurator
    ) async throws -> T
}

final class Network: NetworkLogic {
    private let networkRequest: NetworkRequester
    private let networkDeserialization: NetworkDeserializable

    init(
        networkRequest: NetworkRequester = URLSessionNetworkRequest(),
        networkDeserialization: NetworkDeserializable = NetworkDeserialization()
    ) {
        self.networkRequest = networkRequest
        self.networkDeserialization = networkDeserialization
    }

    func request<T: Decodable>(
        configuration: NetworkRequestConfigurator
    ) async throws -> T {
        let data = try await networkRequest.request(
            url: configuration.baseURL.rawValue + configuration.path,
            method: configuration.method,
            parameters: configuration.parameters,
            headers: configuration.hearders
        )
        
        do {
            return try networkDeserialization.decode(data: data)
        } catch {
            throw error
        }
    }
}
