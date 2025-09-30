import UIKit
import Combine

final class StockViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: StockViewModel
    private let stockView: StockViewDisplaying
    private let loadingView: LoadingViewDisplaying
    private let errorView: ErrorViewDisplaying

    init(
        viewModel: StockViewModel,
        stockView: StockViewDisplaying,
        loadingView: LoadingViewDisplaying,
        errorView: ErrorViewDisplaying
    ) {
        self.viewModel = viewModel
        self.stockView = stockView
        self.loadingView = loadingView
        self.errorView = errorView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
        bindViewModel()
        fetchStock()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupSubviews() {
        [stockView, loadingView, errorView].forEach {
            guard let viewElement = $0 as? UIView else { return }
            view.addSubviewWithoutAutoresizingMask(viewElement)
            NSLayoutConstraint.activate([
                viewElement.topAnchor.constraint(equalTo: view.topAnchor),
                viewElement.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                viewElement.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                viewElement.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &cancellables)
    }

    private func render(state: StockViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            renderLoading()
        case let .content(stock, points):
            renderContent(stock: stock, points: points)
        case let .error(error):
            renderError(error: error)
        }
    }

    private func renderLoading() {
        hideAllViews()
        loadingView.isHidden = false
        loadingView.changeState(state: .loading)
    }

    private func renderContent(stock: Stock, points: [StockPoint]) {
        hideAllViews()
        stockView.isHidden = false
        stockView.setup(stock: stock)
        stockView.drawLineChart(data: points)
    }

    private func renderError(error: Error) {
        hideAllViews()
        errorView.isHidden = false
        errorView.show(error: error, onRetry: { [weak self] in
            self?.fetchStock()
        })
    }

    private func hideAllViews() {
        loadingView.isHidden = true
        stockView.isHidden = true
        errorView.isHidden = true
        loadingView.changeState(state: .stopped)
    }

    private func fetchStock() {
        Task { await viewModel.fetchStock() }
    }
}
