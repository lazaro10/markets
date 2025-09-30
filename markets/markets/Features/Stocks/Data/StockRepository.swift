import Foundation

protocol StockRepository {
    func fetchStock(ticker: String) async throws -> StockResponse
    func fetchStockHistory(ticker: String) async throws -> StockHistoryResponse
}

final class StockRepositoryImplementation: StockRepository {
    private let network: NetworkLogic
    
    init(network: NetworkLogic) {
        self.network = network
    }
    
    func fetchStock(ticker: String) async throws -> StockResponse {
        try await network.request(
            configuration: StockRequest(ticker: ticker)
        )
    }
    
    func fetchStockHistory(ticker: String) async throws -> StockHistoryResponse {
        try await network.request(
            configuration: StockHistoryRequest(symbol: ticker)
        )
    }
}
