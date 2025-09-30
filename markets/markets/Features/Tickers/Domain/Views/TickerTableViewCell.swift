import UIKit

final class TickerTableViewCell: UITableViewCell {
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let pctChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var leftViewStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var rightViewStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, changeLabel, pctChangeLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .trailing
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftViewStack, rightViewStack])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewAttributes()
        setupViewHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(ticker: Ticker) {
        symbolLabel.text = ticker.symbol
        nameLabel.text = ticker.name
        priceLabel.text = ticker.lastsale
        changeLabel.text = ticker.netchange
        pctChangeLabel.text = ticker.pctchange
        changeLabel.textColor = ticker.changeColor
        pctChangeLabel.textColor = ticker.changeColor
    }
    
    private func setupViewAttributes() {
        selectionStyle = .none
    }
    
    private func setupViewHierarchy() {
        contentView.addSubviewWithoutAutoresizingMask(mainStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
