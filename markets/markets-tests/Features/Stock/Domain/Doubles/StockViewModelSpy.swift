import Combine
@testable import markets

final class StockViewModelSpy: StockViewModel {
    enum Message: Equatable {
        case fetchStock
    }

    private(set) var messages: [Message] = []
    private let stateSubject = CurrentValueSubject<StockViewState, Never>(.idle)

    var statePublisher: AnyPublisher<StockViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    func fetchStock() async {
        messages.append(.fetchStock)
    }

    func emitState(_ state: StockViewState) {
        stateSubject.send(state)
    }
}
