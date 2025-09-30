import XCTest
@testable import markets

final class StockHistoryRequestTests: XCTestCase {
    func test_configuration_shouldMatchExpectedPathAndParams() {
        let request = StockHistoryRequest(symbol: "AAPL")

        XCTAssertEqual(request.path, "/api/v2/markets/stock/history")
        XCTAssertEqual(request.parameters["symbol"] as? String, "AAPL")
        XCTAssertEqual(request.parameters["interval"] as? String, "1d")
        XCTAssertEqual(request.parameters["limit"] as? Int, 60)
    }
}
