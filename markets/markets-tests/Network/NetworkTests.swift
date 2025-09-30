import XCTest
import Foundation
@testable import markets

final class NetworkTests: XCTestCase {
    func test_request_successfulFlow_shouldReturnDecodedObject() async throws {
        let (sut, requestSpy, deserializerSpy) = makeSUT()
        let expected = NetworkFixtures.makeResponse()
        let data = try? JSONEncoder().encode(expected)
        
        requestSpy.stubbedData = data
        deserializerSpy.stubbedDecodedValue = expected
        
        let result: NetworkFixtures.Response = try await sut.request(configuration: NetworkFixtures.RequestConfig())
        
        XCTAssertEqual(result.name, expected.name)
        XCTAssertEqual(requestSpy.messages.first, .request(
            url: "https://yahoo-finance15.p.rapidapi.com/path",
            method: .get,
            parameters: ["key": "value"],
            headers: ["Header": "Value"]
        ))
        XCTAssertTrue(deserializerSpy.messages.contains(.decode))
    }
    
    func test_request_withRequestError_shouldThrow() async {
        let (sut, requestSpy, _) = makeSUT()
        requestSpy.errorToThrow = NetworkError.invalidURL
        
        do {
            let _: NetworkFixtures.Response = try await sut.request(configuration: NetworkFixtures.RequestConfig())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
        
        XCTAssertEqual(requestSpy.messages.count, 1)
    }
    
    func test_request_withDeserializationError_shouldThrow() async {
        let (sut, requestSpy, deserializerSpy) = makeSUT()
        requestSpy.stubbedData = Data("{}".utf8)
        deserializerSpy.errorToThrow = NetworkDeserializationError.decodingFailed
        
        do {
            let _: NetworkFixtures.Response = try await sut.request(configuration: NetworkFixtures.RequestConfig())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkDeserializationError, .decodingFailed)
        }
        
        XCTAssertTrue(deserializerSpy.messages.contains(.decode))
    }
    
    private func makeSUT() -> (
        sut: Network,
        requestSpy: NetworkRequesterSpy,
        deserializerSpy: NetworkDeserializerSpy
    ) {
        let requestSpy = NetworkRequesterSpy()
        let deserializerSpy = NetworkDeserializerSpy()
        let sut = Network(networkRequest: requestSpy, networkDeserialization: deserializerSpy)
        return (sut, requestSpy, deserializerSpy)
    }
}
