import UIKit
import Combine

final class TickersViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: TickersViewModel
    private let tickersView: TickersViewDisplaying
    private let loadingView: LoadingViewDisplaying
    private let errorView: ErrorViewDisplaying
    private let emptyState: EmptyStateView

    init(
        viewModel: TickersViewModel,
        tickersView: TickersViewDisplaying,
        loadingView: LoadingViewDisplaying,
        errorView: ErrorViewDisplaying,
        emptyState: EmptyStateView
    ) {
        self.viewModel = viewModel
        self.tickersView = tickersView
        self.loadingView = loadingView
        self.errorView = errorView
        self.emptyState = emptyState
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
        fetchTickers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupSubviews() {
        tickersView.delegate = self
        [tickersView, loadingView, errorView, emptyState].forEach {
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

        viewModel.selectedSymbolPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] symbol in
                self?.navigationController?.pushViewController(
                    StockBuilder.build(symbol: symbol),
                    animated: true
                )
            }
            .store(in: &cancellables)

        viewModel.searchQueryPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tickersView.setup(tickers: self?.viewModel.filteredTickers ?? [])
            }
            .store(in: &cancellables)

        viewModel.isPaginatingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaginating in
                self?.tickersView.showPaginationLoading(isLoading: isPaginating)
            }
            .store(in: &cancellables)
    }

    private func render(state: TickersViewState) {
        switch state {
        case .loading: renderLoading()
        case .content: renderContent()
        case .empty: renderEmpty()
        case .error(let error): renderError(error)
        case .idle: break
        }
    }

    private func renderLoading() {
        hideAllViews()
        loadingView.isHidden = false
        loadingView.changeState(state: .loading)
    }

    private func renderContent() {
        hideAllViews()
        tickersView.isHidden = false
        tickersView.setup(tickers: viewModel.filteredTickers)
    }

    private func renderEmpty() {
        hideAllViews()
        emptyState.isHidden = false
    }

    private func renderError(_ error: Error) {
        hideAllViews()
        errorView.isHidden = false
        errorView.show(error: error, onRetry: { [weak self] in
            Task { await self?.viewModel.fetchInitialTickers() }
        })
    }

    private func hideAllViews() {
        loadingView.isHidden = true
        tickersView.isHidden = true
        errorView.isHidden = true
        emptyState.isHidden = true
        loadingView.changeState(state: .stopped)
    }

    private func fetchTickers() {
        Task { await viewModel.fetchInitialTickers() }
    }
}

extension TickersViewController: TickersViewDelegate {
    func tickersViewDidSearch(text: String) {
        viewModel.updateSearchQuery(text)
    }

    func tickersViewDidScrollToBottom() {
        Task { await viewModel.fetchNextPageIfNeeded() }
    }

    func tickersViewDidPullToRefresh() {
        Task { await viewModel.refreshTickers() }
    }

    func tickersViewDidSelectTicker(row: Int) {
        viewModel.selectTicker(row: row)
    }
}
