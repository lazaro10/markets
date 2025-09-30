enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
}
