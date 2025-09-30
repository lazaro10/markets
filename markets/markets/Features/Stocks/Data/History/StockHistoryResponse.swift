import Foundation

struct StockHistoryResponse: Decodable, Equatable {
    let body: [Body]
    
    struct Body: Decodable, Equatable {
        let timestamp: String
        let close: Double
    }
}
