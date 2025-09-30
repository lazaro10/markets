import Foundation

struct Stock: Equatable {
    let symbol: String
    let address: String
    let sector: String
    let industry: String
    let employees: String
    let summary: String

    init(from response: StockResponse) {
        self.symbol = "Symbol: \(response.meta.symbol ?? "-")"

        let body = response.body
        self.address = "Address: " + [
            body.address1,
            body.city,
            body.state,
            body.country,
            body.zip
        ]
        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
        .joined(separator: ", ")
        self.sector = "Sector: \(body.sector ?? "-")"
        self.industry = "Industry: \(body.industryDisp ?? "-")"
        self.employees = "Employees: \(Self.formatEmployees(employees: body.fullTimeEmployees))"
        self.summary = "Summary:\n\(body.longBusinessSummary ?? "-")"
    }

    private static func formatEmployees(employees: Double?) -> String {
        guard let employees else { return "-" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: employees)) ?? "\(Int(employees))"
    }
}
