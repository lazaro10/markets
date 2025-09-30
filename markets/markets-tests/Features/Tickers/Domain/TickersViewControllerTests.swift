import XCTest
@testable import markets

final class TickersViewControllerTests: XCTestCase {
    @MainActor
    func test_viewDidLoad_triggersFetchInitialTickers() async throws {
        let (sut, viewModel, _, _, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.messages, [.fetchInitialTickers])
    }
    
    @MainActor
    func test_renderLoading_hidesAllAndShowsLoadingView() async throws {
        let (sut, viewModel, tickersView, loadingView, errorView, emptyView) = makeSUT()
        sut.loadViewIfNeeded()
        viewModel.emitState(.loading)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertFalse(loadingView.isHidden)
        XCTAssertTrue(tickersView.isHidden)
        XCTAssertTrue(errorView.isHidden)
        XCTAssertTrue(emptyView.isHidden)
        XCTAssertEqual(loadingView.messages, [.changeState(.stopped), .changeState(.loading)])
    }

    @MainActor
    func test_renderContent_hidesAllAndShowsTickersView() async throws {
        let (sut, viewModel, tickersView, loadingView, errorView, emptyView) = makeSUT()
        sut.loadViewIfNeeded()
        let ticker = TickerFixture.make()
        viewModel.filteredTickers = [ticker]
        viewModel.emitState(.content([]))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(loadingView.isHidden)
        XCTAssertFalse(tickersView.isHidden)
        XCTAssertTrue(errorView.isHidden)
        XCTAssertTrue(emptyView.isHidden)

        XCTAssertTrue(tickersView.messages.contains(.setup([ticker])))
    }

    @MainActor
    func test_renderEmpty_hidesAllAndShowsEmptyView() async throws {
        let (sut, viewModel, tickersView, loadingView, errorView, emptyView) = makeSUT()
        sut.loadViewIfNeeded()
        viewModel.emitState(.empty)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(loadingView.isHidden)
        XCTAssertTrue(tickersView.isHidden)
        XCTAssertTrue(errorView.isHidden)
        XCTAssertFalse(emptyView.isHidden)
    }

    @MainActor
    func test_renderError_hidesAllAndShowsErrorView_andTriggersRetry() async throws {
        let (sut, viewModel, tickersView, loadingView, errorView, emptyView) = makeSUT()
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        sut.loadViewIfNeeded()
        viewModel.emitState(.error(error))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(loadingView.isHidden)
        XCTAssertTrue(tickersView.isHidden)
        XCTAssertFalse(errorView.isHidden)
        XCTAssertTrue(emptyView.isHidden)
        XCTAssertEqual(errorView.messages, [.show(String(describing: error))])
        XCTAssertEqual(viewModel.messages, [.fetchInitialTickers])
    }

    func test_updateSearchQuery_shouldNotifyViewModel_andReloadTickersView() {
        let (sut, viewModel, _, _, _, _) = makeSUT()
        sut.tickersViewDidSearch(text: "test")
        XCTAssertEqual(viewModel.messages, [.updateSearchQuery("test")])
    }

    func test_didSelectTicker_shouldNotifyViewModel() {
        let (sut, viewModel,_ , _, _, _) = makeSUT()
        sut.tickersViewDidSelectTicker(row: 1)
        XCTAssertEqual(viewModel.messages, [.selectTicker(1)])
    }

    @MainActor
    func test_didPullToRefresh_shouldTriggerRefresh() async throws {
        let (sut, viewModel,_ , _, _, _) = makeSUT()
        sut.tickersViewDidPullToRefresh()
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(viewModel.messages, [.refreshTickers])
    }

    @MainActor
    func test_scrollToBottom_shouldTriggerPagination() async throws {
        let (sut, viewModel,_ , _, _, _) = makeSUT()
        sut.tickersViewDidScrollToBottom()
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(viewModel.messages, [.fetchNextPageIfNeeded])
    }

    @MainActor
    func test_emitIsPaginating_shouldNotifyPaginationLoading() async throws {
        let (sut, viewModel, tickersView , _, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        viewModel.emitIsPaginating(true)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(tickersView.messages.last, .showPaginationLoading(true))
    }

    @MainActor
    func test_emitSelectedSymbol_shouldPushStockViewController() async throws {
        let (sut, viewModel, _ , _, _, _) = makeSUT()
        let navigation = UINavigationController(rootViewController: sut)
        UIApplication.shared.currentKeyWindow?.rootViewController = navigation

        viewModel.emitSelectedSymbol("AAPL")
        try await Task.sleep(nanoseconds: 100_000_000) // Melhor e mais seguro
        XCTAssertTrue(navigation.topViewController is StockViewController)
    }
    
    private func makeSUT() -> (
        sut: TickersViewController,
        viewModel: TickersViewModelSpy,
        tickersView: TickersViewSpy,
        loadingView: LoadingViewSpy,
        errorView: ErrorViewSpy,
        emptyView: EmptyStateView
    ) {
        let viewModel = TickersViewModelSpy()
        let tickersView = TickersViewSpy()
        let loadingView = LoadingViewSpy()
        let errorView = ErrorViewSpy()
        let emptyView = EmptyStateView()

        let sut = TickersViewController(
            viewModel: viewModel,
            tickersView: tickersView,
            loadingView: loadingView,
            errorView: errorView,
            emptyState: emptyView
        )
        return (sut, viewModel, tickersView, loadingView, errorView, emptyView)
    }
}

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
