import Foundation

struct URLSessionNetworkRequest: NetworkRequester {
    func request(
        url: String,
        method: NetworkMethod,
        parameters: [String: Any]?,
        headers: [String: String]?
    ) async throws -> Data {
        guard var urlComponents = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        
        if let params = parameters {
            urlComponents.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        return data
    }
}
