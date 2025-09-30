import UIKit
@testable import markets

final class StockViewSpy: UIView, StockViewDisplaying {
    enum Message: Equatable {
        case setup(Stock)
        case drawLineChart([StockPoint])
    }

    private(set) var messages: [Message] = []

    func setup(stock: Stock) {
        messages.append(.setup(stock))
    }

    func drawLineChart(data: [StockPoint]) {
        messages.append(.drawLineChart(data))
    }
}
