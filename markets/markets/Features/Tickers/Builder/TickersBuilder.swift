import UIKit

enum TickersBuilder {
    static func build() -> UIViewController {
        let repository = TickersRepositoryImplementation(network: Network())
        let viewModel = TickersViewModelImplementation(repository: repository)
        let viewController = TickersViewController(
            viewModel: viewModel,
            tickersView: TickersView(),
            loadingView: LoadingView(),
            errorView: ErrorView(),
            emptyState: EmptyStateView()
        )
        viewController.title = "Tickers"
        return viewController
    }
}
