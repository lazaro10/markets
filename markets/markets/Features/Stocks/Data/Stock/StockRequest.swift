struct StockRequest: NetworkRequestConfigurator, Equatable {
    let ticker: String
    
    init(ticker: String) {
        self.ticker = ticker
    }
    
    var path: String {
        "/api/v1/markets/stock/modules"
    }
    
    var parameters: [String: Any] {
        [
            "ticker": ticker,
            "module": "asset-profile",
        ]
    }
}
