@testable import markets
import Combine

final class TickersViewModelSpy: TickersViewModel {
    enum Message: Equatable {
        case fetchInitialTickers
        case refreshTickers
        case fetchNextPageIfNeeded
        case selectTicker(Int)
        case updateSearchQuery(String)
    }
    
    private(set) var messages: [Message] = []
    
    private let stateSubject = CurrentValueSubject<TickersViewState, Never>(.idle)
    private let selectedSymbolSubject = CurrentValueSubject<String?, Never>(nil)
    private let searchQuerySubject = CurrentValueSubject<String, Never>("")
    private let isPaginatingSubject = CurrentValueSubject<Bool, Never>(false)
    
    var statePublisher: AnyPublisher<TickersViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    var selectedSymbolPublisher: AnyPublisher<String?, Never> {
        selectedSymbolSubject.eraseToAnyPublisher()
    }
    
    var searchQueryPublisher: AnyPublisher<String, Never> {
        searchQuerySubject.eraseToAnyPublisher()
    }
    
    var isPaginatingPublisher: AnyPublisher<Bool, Never> {
        isPaginatingSubject.eraseToAnyPublisher()
    }
    
    var filteredTickers: [Ticker] = []
    
    func fetchInitialTickers() async {
        messages.append(.fetchInitialTickers)
    }
    
    func refreshTickers() async {
        messages.append(.refreshTickers)
    }
    
    func fetchNextPageIfNeeded() async {
        messages.append(.fetchNextPageIfNeeded)
    }
    
    func selectTicker(row: Int) {
        messages.append(.selectTicker(row))
    }
    
    func updateSearchQuery(_ query: String) {
        messages.append(.updateSearchQuery(query))
        searchQuerySubject.send(query)
    }
    
    func emitState(_ state: TickersViewState) {
        stateSubject.send(state)
    }
    
    func emitSelectedSymbol(_ symbol: String) {
        selectedSymbolSubject.send(symbol)
    }
    
    func emitIsPaginating(_ isPaginating: Bool) {
        isPaginatingSubject.send(isPaginating)
    }
}
