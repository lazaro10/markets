import Foundation

protocol TickersRepository {
    func fetchTickers(page: Int) async throws -> TickersResponse
}

final class TickersRepositoryImplementation: TickersRepository {
    private let network: NetworkLogic
    
    init(network: NetworkLogic) {
        self.network = network
    }
    
    func fetchTickers(page: Int) async throws -> TickersResponse {
        try await network.request(
            configuration: TickersRequest(page: page)
        )
    }
}
