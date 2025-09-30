import XCTest
@testable import markets
import Combine

final class TickersViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    func test_fetchInitialTickers_shouldEmitLoadingAndContentState() async throws {
        let (sut, repository) = makeSUT()
        
        let body = TickersResponseFixture.makeBody()
        let expectedTicker = Ticker(from: body)
        repository.stubbedResponse = .init(body: [body])
        
        var receivedStates: [TickersViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)
        
        await sut.fetchInitialTickers()
        
        XCTAssertEqual(repository.messages, [.fetchTickers(1)])
        XCTAssertEqual(receivedStates, [.idle, .loading, .content([expectedTicker])])
    }
    
    @MainActor
    func test_fetchInitialTickers_shouldEmitEmptyStateWhenResponseIsEmpty() async throws {
        let (sut, repository) = makeSUT()
        repository.stubbedResponse = .init(body: [])
        
        var receivedStates: [TickersViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)
        
        await sut.fetchInitialTickers()
        
        XCTAssertEqual(receivedStates, [.idle, .loading, .empty])
    }
    
    @MainActor
    func test_fetchInitialTickers_shouldEmitErrorStateOnFailure() async throws {
        let (sut, repository) = makeSUT()
        repository.errorToThrow = NSError(domain: "Test", code: 0)
        
        var receivedStates: [TickersViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)
        
        await sut.fetchInitialTickers()
        
        guard case .error = receivedStates.last else {
            XCTFail("Expected error state")
            return
        }
    }
    
    @MainActor
    func test_refreshTickers_shouldResetPageAndEmitCorrectState() async throws {
        let (sut, repository) = makeSUT()

        let body = TickersResponseFixture.makeBody()
        let expectedTicker = Ticker(from: body)
        repository.stubbedResponse = .init(body: [body])
        
        var receivedStates: [TickersViewState] = []
        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)
        
        await sut.refreshTickers()
        
        XCTAssertEqual(repository.messages, [.fetchTickers(1)])
        XCTAssertEqual(receivedStates, [.idle, .content([expectedTicker])])
    }
    
    @MainActor
    func test_fetchNextPageIfNeeded_shouldPaginateAndAppendResults() async throws {
        let (sut, repository) = makeSUT()
        let initialTickers = (1...5).map { TickerFixture.make(symbol: "\($0)") }
        let nextPageTickers = [TickerFixture.make(symbol: "6")]
        sut.updateSearchQuery("")
        
        repository.stubbedResponse = .init(body: initialTickers.map(\.responseBody))
        await sut.fetchInitialTickers()
        
        repository.stubbedResponse = .init(body: nextPageTickers.map(\.responseBody))
        await sut.fetchNextPageIfNeeded()
        
        let expectedSymbols = (1...6).map { "\($0)" }
        let resultSymbols = sut.filteredTickers.map(\.symbol)
        
        XCTAssertEqual(resultSymbols, expectedSymbols)
    }
    
    @MainActor
    func test_fetchNextPageIfNeeded_shouldNotPaginateIfNotEnoughTickers() async throws {
        let (sut, repository) = makeSUT()
        repository.stubbedResponse = .init(body: [TickerFixture.make().responseBody])
        
        await sut.fetchInitialTickers()
        await sut.fetchNextPageIfNeeded()
        
        XCTAssertEqual(repository.messages, [.fetchTickers(1)])
    }
    
    func test_selectTicker_shouldPublishSelectedSymbol() {
        let (sut, _) = makeSUT()
        let ticker = TickerFixture.make()
        
        sut.updateSearchQuery("")
        sut.injectTickersForTesting([ticker])
        
        let expectation = XCTestExpectation(description: "Selected symbol emitted")
        var selectedSymbol: String?
        
        sut.selectedSymbolPublisher
            .dropFirst()
            .sink {
                selectedSymbol = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.selectTicker(row: 0)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(selectedSymbol, ticker.symbol)
    }
    
    func test_updateSearchQuery_shouldUpdateFilteredTickers() {
        let (sut, _) = makeSUT()
        let tickers = [
            TickerFixture.make(symbol: "AAPL"),
            TickerFixture.make(symbol: "GOOG"),
            TickerFixture.make(symbol: "AMZN")
        ]
        
        sut.updateSearchQuery("")
        sut.injectTickersForTesting(tickers)
        
        sut.updateSearchQuery("AAP")
        let result = sut.filteredTickers
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.symbol, "AAPL")
    }
    
    private func makeSUT() -> (
        sut: TickersViewModelImplementation,
        repository: TickersRepositorySpy
    ) {
        let repository = TickersRepositorySpy()
  
        let sut = TickersViewModelImplementation(
            repository: repository
        )
        
        return (sut, repository)
    }
}

extension Ticker {
    var responseBody: TickersResponse.Body {
        .init(symbol: symbol, name: name, lastsale: lastsale, netchange: netchange, pctchange: pctchange)
    }
}

extension TickersViewState: @retroactive Equatable {
    public static func == (lhs: TickersViewState, rhs: TickersViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.loading, .loading),
            (.empty, .empty):
            return true
        case let (.content(lhsTickers), .content(rhsTickers)):
            return lhsTickers == rhsTickers
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
