@testable import markets

struct StockResponseFixture {
    static func makeResponse(
        meta: StockResponse.Meta = makeMeta(),
        body: StockResponse.Body = makeBody()
    ) -> StockResponse {
        .init(meta: meta, body: body)
    }

    static func makeMeta(symbol: String? = "AAPL") -> StockResponse.Meta {
        .init(symbol: symbol)
    }

    static func makeBody(
        address1: String? = "1 Infinite Loop",
        city: String? = "Cupertino",
        state: String? = "CA",
        zip: String? = "95014",
        country: String? = "United States",
        sector: String? = "Technology",
        industryDisp: String? = "Consumer Electronics",
        fullTimeEmployees: Double? = 164000,
        longBusinessSummary: String? = "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets..."
    ) -> StockResponse.Body {
        .init(
            address1: address1,
            city: city,
            state: state,
            zip: zip,
            country: country,
            sector: sector,
            industryDisp: industryDisp,
            fullTimeEmployees: fullTimeEmployees,
            longBusinessSummary: longBusinessSummary
        )
    }
}
