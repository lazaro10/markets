struct StockHistoryRequest: NetworkRequestConfigurator {
    let symbol: String

    var path: String {
        "/api/v2/markets/stock/history"
    }

    var parameters: [String: Any] {
        [
            "symbol": symbol,
            "interval": "1d",
            "limit": 60
        ]
    }
}
