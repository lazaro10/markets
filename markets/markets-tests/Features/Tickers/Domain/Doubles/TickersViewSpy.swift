import UIKit
@testable import markets

final class TickersViewSpy: UIView, TickersViewDisplaying {
    enum Message: Equatable {
        case setup([Ticker])
        case showPaginationLoading(Bool)
    }

    private(set) var messages: [Message] = []
    
    var delegate: TickersViewDelegate?

    func setup(tickers: [Ticker]) {
        messages.append(.setup(tickers))
    }

    func showPaginationLoading(isLoading: Bool) {
        messages.append(.showPaginationLoading(isLoading))
    }
}
