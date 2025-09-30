import Combine

protocol StockViewModel: AnyObject {
    var statePublisher: AnyPublisher<StockViewState, Never> { get }

    func fetchStock() async
}

enum StockViewState {
    case idle
    case loading
    case content(stock: Stock, points: [StockPoint])
    case error(Error)
}

final class StockViewModelImplementation: StockViewModel {
    @Published private var state: StockViewState = .idle

    private let repository: StockRepository
    private let symbol: String

    init(repository: StockRepository, symbol: String) {
        self.repository = repository
        self.symbol = symbol
    }

    var statePublisher: AnyPublisher<StockViewState, Never> {
        $state.eraseToAnyPublisher()
    }

    @MainActor
    func fetchStock() async {
        state = .loading

        async let stockResponse = repository.fetchStock(ticker: symbol)
        async let historyResponse = repository.fetchStockHistory(ticker: symbol)

        do {
            let (stockResult, historyResult) = try await (stockResponse, historyResponse)
            let stock = Stock(from: stockResult)
            let points: [StockPoint] = historyResult.body.map { .init(stock: $0) }
            state = .content(stock: stock, points: points)
        } catch {
            state = .error(error)
        }
    }
}
