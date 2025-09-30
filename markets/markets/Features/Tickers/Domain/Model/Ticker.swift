import UIKit

struct Ticker: Hashable, Searchable, Equatable {
    let symbol: String
    let name: String
    let lastsale: String

    private let rawNetChange: String
    private let rawPctChange: String

    init(from body: TickersResponse.Body) {
        self.symbol = body.symbol
        self.name = body.name
        self.lastsale = body.lastsale
        self.rawNetChange = body.netchange
        self.rawPctChange = body.pctchange
    }

    var netchange: String {
        "Change: \(rawNetChange)"
    }

    var pctchange: String {
        "(\(rawPctChange))"
    }

    var isPositiveChange: Bool {
        rawNetChange.trimmingCharacters(in: .whitespaces).hasPrefix("+") ||
        rawPctChange.trimmingCharacters(in: .whitespaces).hasPrefix("+") ||
        (!rawNetChange.trimmingCharacters(in: .whitespaces).hasPrefix("-") &&
         !rawPctChange.trimmingCharacters(in: .whitespaces).hasPrefix("-"))
    }

    var changeColor: UIColor {
        isPositiveChange ? .systemGreen : .systemRed
    }

    func matches(query: String) -> Bool {
        symbol.lowercased().contains(query.lowercased()) ||
        name.lowercased().contains(query.lowercased())
    }
}
