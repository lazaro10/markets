import XCTest
@testable import markets

final class StockRequestTests: XCTestCase {
    func test_configuration_shouldMatchExpectedPathAndParams() {
        let request = StockRequest(ticker: "AAPL")

        XCTAssertEqual(request.path, "/api/v1/markets/stock/modules")
        XCTAssertEqual(request.parameters["ticker"] as? String, "AAPL")
        XCTAssertEqual(request.parameters["module"] as? String, "asset-profile")
    }
}
