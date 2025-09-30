import UIKit

class EmptyStateView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing was found."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        addSubviewWithoutAutoresizingMask(messageLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
