@testable import markets

final class StockRepositorySpy: StockRepository {
    enum Message: Equatable {
        case fetchStock(String)
        case fetchStockHistory(String)
    }

    private(set) var messages: [Message] = []

    var stubbedStockResponse: StockResponse?
    var stubbedStockHistoryResponse: StockHistoryResponse?
    var errorToThrow: Error?

    func fetchStock(ticker: String) async throws -> StockResponse {
        messages.append(.fetchStock(ticker))

        if let errorToThrow { throw errorToThrow }
        if let response = stubbedStockResponse { return response }

        fatalError("No stubbed StockResponse provided")
    }

    func fetchStockHistory(ticker: String) async throws -> StockHistoryResponse {
        messages.append(.fetchStockHistory(ticker))

        if let errorToThrow { throw errorToThrow }
        if let response = stubbedStockHistoryResponse { return response }

        fatalError("No stubbed StockHistoryResponse provided")
    }
}
