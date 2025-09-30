@testable import markets

final class TickersRepositorySpy: TickersRepository {
    enum Message: Equatable {
        case fetchTickers(Int)
    }

    private(set) var messages: [Message] = []
    var stubbedResponse: TickersResponse?
    var errorToThrow: Error?

    func fetchTickers(page: Int) async throws -> TickersResponse {
        messages.append(.fetchTickers(page))

        if let errorToThrow { throw errorToThrow }
        if let stubbedResponse { return stubbedResponse }

        fatalError("No stubbed response provided")
    }
}
