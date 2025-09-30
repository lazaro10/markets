@testable import markets

final class NetworkSpy: NetworkLogic {
    enum Message: Equatable {
        case request(NetworkRequestConfiguratorSpy)
    }

    private(set) var messages: [Message] = []
    var stubbedResponse: Any?
    var errorToThrow: Error?

    func request<T>(configuration: NetworkRequestConfigurator) async throws -> T where T : Decodable {
        messages.append(.request(NetworkRequestConfiguratorSpy(from: configuration)))

        if let error = errorToThrow {
            throw error
        }

        guard let result = stubbedResponse as? T else {
            fatalError("Could not cast stubbedResponse to expected type \(T.self)")
        }
        return result
    }
}
