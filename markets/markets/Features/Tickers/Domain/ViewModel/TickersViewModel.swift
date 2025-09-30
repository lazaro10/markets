import Combine

enum TickersViewState {
    case idle
    case loading
    case content([Ticker])
    case empty
    case error(Error)
}

protocol TickersViewModel: AnyObject {
    var statePublisher: AnyPublisher<TickersViewState, Never> { get }
    var selectedSymbolPublisher: AnyPublisher<String?, Never> { get }
    var searchQueryPublisher: AnyPublisher<String, Never> { get }
    var isPaginatingPublisher: AnyPublisher<Bool, Never> { get }
    var filteredTickers: [Ticker] { get }
    
    func fetchInitialTickers() async
    func refreshTickers() async
    func fetchNextPageIfNeeded() async
    func selectTicker(row: Int)
    func updateSearchQuery(_ query: String)
}

final class TickersViewModelImplementation: TickersViewModel {
    @Published private var state: TickersViewState = .idle
    @Published private var tickerSelectedSymbol: String?
    @Published private var searchQuery: String = ""
    @Published private var isPaginating: Bool = false
    
    private var tickers: [Ticker] = []
    private var currentPage: Int = 1
    private let repository: TickersRepository
    
    init(repository: TickersRepository) {
        self.repository = repository
    }
    
    // MARK: - Outputs
    
    var statePublisher: AnyPublisher<TickersViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var selectedSymbolPublisher: AnyPublisher<String?, Never> {
        $tickerSelectedSymbol.eraseToAnyPublisher()
    }
    
    var searchQueryPublisher: AnyPublisher<String, Never> {
        $searchQuery.eraseToAnyPublisher()
    }
    
    var isPaginatingPublisher: AnyPublisher<Bool, Never> {
        $isPaginating.eraseToAnyPublisher()
    }
    
    var filteredTickers: [Ticker] {
        guard !searchQuery.isEmpty else { return tickers }
        return tickers.filter { $0.matches(query: searchQuery) }
    }
    
    // MARK: - Inputs
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
    }
    
    func selectTicker(row: Int) {
        tickerSelectedSymbol = filteredTickers[row].symbol
    }
    
    @MainActor
    func fetchInitialTickers() async {
        state = .loading
        currentPage = 1
        tickers = []
        await loadTickers(page: currentPage, isRefreshing: false)
    }
    
    @MainActor
    func refreshTickers() async {
        currentPage = 1
        tickers = []
        await loadTickers(page: currentPage, isRefreshing: true)
    }
    
    @MainActor
    func fetchNextPageIfNeeded() async {
        guard !isPaginating, tickers.count >= 5 else { return }
        isPaginating = true
        currentPage += 1
        await loadTickers(page: currentPage, isRefreshing: false)
    }
    
    @MainActor
    private func loadTickers(page: Int, isRefreshing: Bool) async {
        defer { isPaginating = false }
        
        do {
            let response = try await repository.fetchTickers(page: page)
            let newTickers = response.body.map { Ticker(from: $0) }
            
            if page == 1 {
                tickers = newTickers
            } else {
                tickers += newTickers
            }
            
            if tickers.isEmpty {
                state = .empty
            } else {
                state = .content(tickers)
            }
        } catch {
            if page == 1 || isRefreshing {
                state = .error(error)
            }
        }
    }
}

#if DEBUG
extension TickersViewModelImplementation {
    func injectTickersForTesting(_ tickers: [Ticker]) {
        self.tickers = tickers
    }
}
#endif
