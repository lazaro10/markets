import XCTest
@testable import markets

final class StockRepositoryTests: XCTestCase {
    func test_fetchStock_shouldCallNetworkWithCorrectRequest() async throws {
        let (sut, networkSpy) = makeSUT()
        let expectedResponse = StockResponseFixture.makeResponse()
        networkSpy.stubbedResponse = expectedResponse

        let result = try await sut.fetchStock(ticker: "AAPL")

        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(
            networkSpy.messages.first,
            .request(NetworkRequestConfiguratorSpy(from: StockRequest(ticker: "AAPL")))
        )
    }

    func test_fetchStockHistory_shouldCallNetworkWithCorrectRequest() async throws {
        let (sut, networkSpy) = makeSUT()
        let expectedResponse = StockHistoryResponseFixture.makeResponse()
        networkSpy.stubbedResponse = expectedResponse

        let result = try await sut.fetchStockHistory(ticker: "AAPL")

        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(
            networkSpy.messages.first,
            .request(NetworkRequestConfiguratorSpy(from: StockHistoryRequest(symbol: "AAPL")))
        )
    }

    private func makeSUT() -> (
        sut: StockRepositoryImplementation,
        networkSpy: NetworkSpy
    ) {
        let networkSpy = NetworkSpy()
        let sut = StockRepositoryImplementation(network: networkSpy)
        return (sut, networkSpy)
    }
}
