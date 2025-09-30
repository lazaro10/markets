@testable import markets

struct StockHistoryResponseFixture {
    static func makeResponse(body: [StockHistoryResponse.Body] = [makeBody()]) -> StockHistoryResponse {
        .init(body: body)
    }

    static func makeBody(
        timestamp: String = "2025-07-18T16:00:00Z",
        close: Double = 185.23
    ) -> StockHistoryResponse.Body {
        .init(
            timestamp: timestamp,
            close: close
        )
    }
}
