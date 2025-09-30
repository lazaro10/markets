import UIKit

enum StockBuilder {
    static func build(symbol: String) -> UIViewController {
        let repository = StockRepositoryImplementation(network: Network())
        let viewModel = StockViewModelImplementation(
            repository: repository,
            symbol: symbol
        )
        let viewController = StockViewController(
            viewModel: viewModel,
            stockView: StockView(),
            loadingView: LoadingView(),
            errorView: ErrorView()
        )
        viewController.title = symbol
        return viewController
    }
}
