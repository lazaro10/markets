import XCTest
@testable import markets

final class NetworkDeserializationTests: XCTestCase {
    func test_decode_validData_shouldReturnDecodedObject() throws {
        let sut = makeSUT()
        let expected = NetworkFixtures.makeResponse()
        let data = try JSONEncoder().encode(expected)

        let decoded: NetworkFixtures.Response = try sut.decode(data: data)

        XCTAssertEqual(decoded.name, expected.name)
    }

    func test_decode_nilData_shouldThrowInvalidData() {
        let sut = makeSUT()

        XCTAssertThrowsError(try sut.decode(data: nil) as NetworkFixtures.Response) { error in
            XCTAssertEqual(error as? NetworkDeserializationError, .invalidData)
        }
    }

    func test_decode_invalidJSON_shouldThrowDecodingFailed() {
        let sut = makeSUT()
        let data = Data("invalid json".utf8)

        XCTAssertThrowsError(try sut.decode(data: data) as NetworkFixtures.Response) { error in
            XCTAssertEqual(error as? NetworkDeserializationError, .decodingFailed)
        }
    }

    private func makeSUT() -> NetworkDeserialization {
        NetworkDeserialization()
    }
}
