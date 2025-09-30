import UIKit

protocol TickersViewDisplaying: UIView {
    func setup(tickers: [Ticker])
    func showPaginationLoading(isLoading: Bool)
    var delegate: TickersViewDelegate? { get set }
}

protocol TickersViewDelegate: AnyObject {
    func tickersViewDidSearch(text: String)
    func tickersViewDidScrollToBottom()
    func tickersViewDidPullToRefresh()
    func tickersViewDidSelectTicker(row: Int)
}

final class TickersView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.tableFooterView = paginationIndicator
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self, action: #selector(refreshTriggered), for: .valueChanged
        )
        return refreshControl
    }()
    
    private let paginationIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var tickersDataSourceAdapter = TickersDataSourceAdapter(
        tableView: tableView
    )
    
    weak var delegate: TickersViewDelegate?
    
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
    }
    
    private func setupViewHierarchy() {
        addSubviewWithoutAutoresizingMask(stackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        paginationIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
    }
    
    @objc private func refreshTriggered() {
        delegate?.tickersViewDidPullToRefresh()
    }
}

extension TickersView: TickersViewDisplaying {
    func setup(tickers: [Ticker]) {
        tickersDataSourceAdapter.apply(tickers: tickers)
        refreshControl.endRefreshing()
    }
    
    func showPaginationLoading(isLoading: Bool) {
        if isLoading {
            paginationIndicator.startAnimating()
        } else {
            paginationIndicator.stopAnimating()
        }
    }
}

extension TickersView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - visibleHeight - 100 {
            delegate?.tickersViewDidScrollToBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tickersViewDidSelectTicker(row: indexPath.row)
    }
}

extension TickersView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.tickersViewDidSearch(text: searchText)
    }
}
