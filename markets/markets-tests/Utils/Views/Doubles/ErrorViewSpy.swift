import UIKit
@testable import markets

final class ErrorViewSpy: UIView, ErrorViewDisplaying {
    enum Message: Equatable {
        case show(String)
    }

    private(set) var messages: [Message] = []
    private(set) var onRetry: (() -> Void)?

    func show(error: Error, onRetry: @escaping () -> Void) {
        messages.append(.show(String(describing: error)))
        self.onRetry = onRetry
    }
}
