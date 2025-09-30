import UIKit
@testable import markets

final class LoadingViewSpy: UIView, LoadingViewDisplaying {
    enum Message: Equatable {
        case changeState(LoadingView.State)
    }

    private(set) var messages: [Message] = []
    
    func changeState(state: LoadingView.State) {
        messages.append(.changeState(state))
    }
}
