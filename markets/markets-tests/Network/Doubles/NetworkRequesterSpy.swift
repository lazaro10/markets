import Foundation
@testable import markets

final class NetworkRequesterSpy: NetworkRequester {
    enum Message {
        case request(url: String, method: NetworkMethod, parameters: [String: Any]?, headers: [String: String]?)
    }
    
    private(set) var messages: [Message] = []
    
    var stubbedData: Data?
    var errorToThrow: Error?
    
    func request(
        url: String,
        method: NetworkMethod,
        parameters: [String: Any]?,
        headers: [String: String]?
    ) async throws -> Data {
        messages.append(.request(url: url, method: method, parameters: parameters, headers: headers))
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        return stubbedData ?? Data()
    }
}

extension NetworkRequesterSpy.Message: Equatable {
    static func == (lhs: NetworkRequesterSpy.Message, rhs: NetworkRequesterSpy.Message) -> Bool {
        switch (lhs, rhs) {
        case let (.request(lURL, lMethod, _, lHeaders), .request(rURL, rMethod, _, rHeaders)):
            return lURL == rURL && lMethod == rMethod && lHeaders == rHeaders
        }
    }
}
