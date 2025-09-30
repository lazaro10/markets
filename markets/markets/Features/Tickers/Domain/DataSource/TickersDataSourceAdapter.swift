import UIKit

final class TickersDataSourceAdapter {
    private let tableView: UITableView
    private lazy var dataSource = makeDataSource()

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.dataSource = dataSource
        self.tableView.register(TickerTableViewCell.self)
    }

    func apply(tickers: [Ticker]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
        snapshot.appendSections([0])
        snapshot.appendItems(tickers, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Ticker> {
        UITableViewDiffableDataSource<Int, Ticker>(tableView: tableView) { tableView, indexPath, ticker in
            let cell: TickerTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(ticker: ticker)
            return cell
        }
    }
}
