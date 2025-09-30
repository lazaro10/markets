@testable import markets

struct TickersResponseFixture {
    static func makeResponse(body: [TickersResponse.Body] = [makeBody()]) -> TickersResponse {
        .init(body: body)
    }

    static func makeBody(
        symbol: String = "AAPL",
        name: String = "Apple Inc",
        lastsale: String = "$150.00",
        netchange: String = "+2.50",
        pctchange: String = "+1.70%"
    ) -> TickersResponse.Body {
        .init(
            symbol: symbol,
            name: name,
            lastsale: lastsale,
            netchange: netchange,
            pctchange: pctchange
        )
    }
}
