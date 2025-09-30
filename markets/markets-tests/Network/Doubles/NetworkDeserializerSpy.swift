import Foundation
@testable import markets

final class NetworkDeserializerSpy: NetworkDeserializable {
    enum Message: Equatable {
        case decode
    }
    
    private(set) var messages: [Message] = []
    
    var stubbedDecodedValue: Any?
    var errorToThrow: Error?
    
    func decode<T: Decodable>(data: Data?) throws -> T {
        messages.append(.decode)
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        guard let value = stubbedDecodedValue as? T else {
            throw NetworkDeserializationError.decodingFailed
        }
        
        return value
    }
}
