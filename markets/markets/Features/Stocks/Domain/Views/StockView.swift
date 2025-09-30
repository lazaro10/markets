import UIKit

protocol StockViewDisplaying: UIView {
    func setup(stock: Stock)
    func drawLineChart(data: [StockPoint])
}

final class StockView: UIView {
    private let graphContainerView = StockGraphView()

    private let symbolLabel = UILabel()
    private let sectorLabel = UILabel()
    private let industryLabel = UILabel()
    private let employeesLabel = UILabel()
    private let addressLabel = UILabel()
    private let summaryLabel = UILabel()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            symbolLabel,
            sectorLabel,
            industryLabel,
            employeesLabel,
            addressLabel,
            summaryLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            graphContainerView,
            labelsStackView
        ])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()

    init() {
        super.init(frame: .zero)
        setupViewAttributes()
        setupViewHierarchy()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewAttributes() {
        backgroundColor = .systemBackground

        [symbolLabel, sectorLabel, industryLabel, employeesLabel, addressLabel, summaryLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.numberOfLines = 0
        }

        summaryLabel.font = UIFont.systemFont(ofSize: 14)
        summaryLabel.textColor = .secondaryLabel
    }

    private func setupViewHierarchy() {
        addSubviewWithoutAutoresizingMask(scrollView)
        scrollView.addSubviewWithoutAutoresizingMask(scrollContentView)
        scrollContentView.addSubviewWithoutAutoresizingMask(contentStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16)
        ])
    }
}

extension StockView: StockViewDisplaying {
    func setup(stock: Stock) {
        symbolLabel.text = stock.symbol
        sectorLabel.text = stock.sector
        industryLabel.text = stock.industry
        employeesLabel.text = stock.employees
        addressLabel.text = stock.address
        summaryLabel.text = stock.summary
    }

    func drawLineChart(data: [StockPoint]) {
        graphContainerView.draw(data: data)
    }
}
