@testable import markets

enum TickerFixture {
    static func make(
        symbol: String = "AAPL",
        name: String = "Apple Inc.",
        lastsale: String = "$180.00",
        netchange: String = "+1.20",
        pctchange: String = "+0.67%"
    ) -> Ticker {
        let body = TickersResponse.Body(
            symbol: symbol,
            name: name,
            lastsale: lastsale,
            netchange: netchange,
            pctchange: pctchange
        )
        return Ticker(from: body)
    }
}
