import Foundation

struct StockPoint: Equatable {
    let timestamp: String
    let close: Double

    init(stock: StockHistoryResponse.Body) {
        timestamp = stock.timestamp
        close = stock.close
    }
}
