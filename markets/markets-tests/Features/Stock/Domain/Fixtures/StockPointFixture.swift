@testable import markets

enum StockPointFixture {
    static func make(
        timestamp: String = "2025-07-17",
        close: Double = 185.23
    ) -> StockPoint {
        let response = StockHistoryResponse.Body(
            timestamp: timestamp,
            close: close
        )
        return StockPoint(stock: response)
    }
}
