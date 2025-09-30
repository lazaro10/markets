struct TickersRequest: NetworkRequestConfigurator, Equatable {
    private let page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    var path: String {
        "/api/v2/markets/tickers"
    }
    
    var parameters: [String: Any] {
        [
            "page": page,
            "type": "STOCKS",
        ]
    }
}
