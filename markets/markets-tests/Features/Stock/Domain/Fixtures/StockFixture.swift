@testable import markets

enum StockFixture {
    static func make(
        symbol: String? = "AAPL",
        address1: String? = "1 Infinite Loop",
        city: String? = "Cupertino",
        state: String? = "CA",
        zip: String? = "95014",
        country: String? = "USA",
        sector: String? = "Technology",
        industry: String? = "Consumer Electronics",
        fullTimeEmployees: Double? = 150_000,
        longBusinessSummary: String? = "Apple designs and sells consumer electronics."
    ) -> Stock {
        let response = StockResponse(
            meta: .init(symbol: symbol),
            body: .init(
                address1: address1,
                city: city,
                state: state,
                zip: zip,
                country: country,
                sector: sector,
                industryDisp: industry,
                fullTimeEmployees: fullTimeEmployees,
                longBusinessSummary: longBusinessSummary
            )
        )
        return Stock(from: response)
    }
}
