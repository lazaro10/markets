import Foundation

protocol NetworkDeserializable {
    func decode<T: Decodable>(data: Data?) throws -> T
}

struct NetworkDeserialization: NetworkDeserializable {
    func decode<T: Decodable>(data: Data?) throws -> T {
        guard let data else { throw NetworkDeserializationError.invalidData }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkDeserializationError.decodingFailed
        }
    }
}

enum NetworkDeserializationError: Error {
    case invalidData
    case decodingFailed
}
