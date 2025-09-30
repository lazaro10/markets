import UIKit

protocol ErrorViewDisplaying: UIView {
    func show(error: Error, onRetry: @escaping () -> Void)
}

final class ErrorView: UIView, ErrorViewDisplaying {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try again", for: .normal)
        return button
    }()

    private var retryAction: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupViewAttributes()
        setupViewHierarchy()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(error: Error, onRetry: @escaping () -> Void) {
        messageLabel.text = error.localizedDescription
        retryAction = onRetry
    }
    
    private func setupViewAttributes() {
        backgroundColor = .systemBackground
    }

    private func setupViewHierarchy() {
        addSubviewWithoutAutoresizingMask(messageLabel)
        addSubviewWithoutAutoresizingMask(retryButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupActions() {
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }

    @objc private func didTapRetry() {
        retryAction?()
    }
}
