import XCTest
@testable import markets
import Combine

final class StockViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    @MainActor
    func test_fetchStock_shouldEmitLoadingAndContent() async throws {
        let (sut, repository) = makeSUT()
        let stockResponse = StockResponseFixture.makeResponse()
        let historyResponse = StockHistoryResponseFixture.makeResponse()
        let expectedStock = Stock(from: stockResponse)
        let expectedPoints = historyResponse.body.map { StockPoint(stock: $0) }

        repository.stubbedStockResponse = stockResponse
        repository.stubbedStockHistoryResponse = historyResponse

        var receivedStates: [StockViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)

        await sut.fetchStock()

        XCTAssertEqual(receivedStates.count, 3)
        XCTAssertEqual(receivedStates[0], .idle)
        XCTAssertEqual(receivedStates[1], .loading)

        if case let .content(stock, points) = receivedStates[2] {
            XCTAssertEqual(stock.symbol, expectedStock.symbol)
            XCTAssertEqual(points.map(\ .timestamp), expectedPoints.map(\ .timestamp))
        } else {
            XCTFail("Expected content state")
        }
    }

    @MainActor
    func test_fetchStock_shouldEmitError_onFailure() async throws {
        let (sut, repository) = makeSUT()
        repository.errorToThrow = NSError(domain: "Test", code: 0)

        var receivedStates: [StockViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)

        await sut.fetchStock()

        XCTAssertEqual(receivedStates.count, 3)
        XCTAssertEqual(receivedStates[0], .idle)
        XCTAssertEqual(receivedStates[1], .loading)

        guard case .error = receivedStates[2] else {
            XCTFail("Expected error state")
            return
        }
    }

    private func makeSUT() -> (
        sut: StockViewModelImplementation,
        repository: StockRepositorySpy
    ) {
        let repository = StockRepositorySpy()
        let sut = StockViewModelImplementation(repository: repository, symbol: "AAPL")
        return (sut, repository)
    }
}

extension StockViewState: @retroactive Equatable {
    public static func == (lhs: StockViewState, rhs: StockViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading):
            return true
        case let (.content(lStock, lPoints), .content(rStock, rPoints)):
            return lStock.symbol == rStock.symbol &&
                   lPoints.map(\ .timestamp) == rPoints.map(\ .timestamp)
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
