import XCTest
@testable import markets

@MainActor
final class StockViewControllerTests: XCTestCase {
    func test_viewDidLoad_shouldTriggerFetchStock() async throws {
        let (sut, viewModel, _, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(viewModel.messages, [.fetchStock])
    }

    func test_renderLoading_shouldShowOnlyLoadingView() async throws {
        let (sut, viewModel, stockView, loadingView, errorView) = makeSUT()
        sut.loadViewIfNeeded()
        viewModel.emitState(.loading)
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(loadingView.isHidden)
        XCTAssertTrue(stockView.isHidden)
        XCTAssertTrue(errorView.isHidden)
        XCTAssertEqual(loadingView.messages, [.changeState(.stopped), .changeState(.loading)])
    }

    func test_renderContent_shouldShowOnlyStockView() async throws {
        let (sut, viewModel, stockView, loadingView, errorView) = makeSUT()
        sut.loadViewIfNeeded()
        let stock = StockFixture.make()
        let points = [StockPointFixture.make()]
        viewModel.emitState(.content(stock: stock, points: points))
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(loadingView.isHidden)
        XCTAssertFalse(stockView.isHidden)
        XCTAssertTrue(errorView.isHidden)
        XCTAssertEqual(stockView.messages, [.setup(stock), .drawLineChart(points)])
    }

    @MainActor
    func test_renderError_hidesAllAndShowsErrorView_andTriggersRetry() async throws {
        let (sut, viewModel, tickersView, loadingView, errorView) = makeSUT()
        let error = NSError(domain: "Test", code: 1)
        sut.loadViewIfNeeded()
        viewModel.emitState(.error(error))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(loadingView.isHidden)
        XCTAssertTrue(tickersView.isHidden)
        XCTAssertFalse(errorView.isHidden)
        XCTAssertEqual(errorView.messages, [.show(String(describing: error))])
        XCTAssertEqual(viewModel.messages, [.fetchStock])
    }

    private func makeSUT() -> (
        sut: StockViewController,
        viewModel: StockViewModelSpy,
        stockView: StockViewSpy,
        loadingView: LoadingViewSpy,
        errorView: ErrorViewSpy
    ) {
        let viewModel = StockViewModelSpy()
        let stockView = StockViewSpy()
        let loadingView = LoadingViewSpy()
        let errorView = ErrorViewSpy()
        let sut = StockViewController(
            viewModel: viewModel,
            stockView: stockView,
            loadingView: loadingView,
            errorView: errorView
        )
        return (sut, viewModel, stockView, loadingView, errorView)
    }
}
