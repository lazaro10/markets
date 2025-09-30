import UIKit

protocol LoadingViewDisplaying: UIView {
    func changeState(state: LoadingView.State)
}

final class LoadingView: UIView, LoadingViewDisplaying {
    enum State {
        case loading
        case stopped
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init() {
        super.init(frame: .zero)
        setupViewAttributes()
        setupViewHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewAttributes() {
        backgroundColor = .systemBackground
    }

    private func setupViewHierarchy() {
        addSubviewWithoutAutoresizingMask(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func changeState(state: LoadingView.State) {
        switch state {
        case .loading:
            isHidden = false
            activityIndicator.startAnimating()
        case .stopped:
            isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}
