import XCTest
@testable import markets

final class TickersRepositoryTests: XCTestCase {
    func test_fetchTickers_shouldCallNetworkWithCorrectRequest() async throws {
        let (sut, networkSpy) = makeSUT()
        let response = TickersResponseFixture.makeResponse()
        networkSpy.stubbedResponse = response

        let result = try await sut.fetchTickers(page: 1)

        XCTAssertEqual(result, response)
        XCTAssertEqual(
            networkSpy.messages.first,
            .request(NetworkRequestConfiguratorSpy(from: TickersRequest(page: 1)))
        )
    }

    private func makeSUT() -> (
        sut: TickersRepositoryImplementation,
        networkSpy: NetworkSpy
    ) {
        let networkSpy = NetworkSpy()
        let sut = TickersRepositoryImplementation(network: networkSpy)
        return (sut, networkSpy)
    }
}
