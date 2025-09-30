import XCTest
@testable import markets

final class TickersRequestTests: XCTestCase {
    func test_configuration_shouldMatchExpectedPathAndParams() {
        let request = TickersRequest(page: 2)

        XCTAssertEqual(request.path, "/api/v2/markets/tickers")
        XCTAssertEqual(request.parameters["page"] as? Int, 2)
        XCTAssertEqual(request.parameters["type"] as? String, "STOCKS")
    }
}
