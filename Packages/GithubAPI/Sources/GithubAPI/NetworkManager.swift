import Foundation

final public class NetworkManager {
    private static let defaultClient = DefaultNetworkClient()
    
    static func request<V: Decodable>(
        _ networkRequest: NetworkRequest
    ) async throws -> V {
        try await Self.request(client: defaultClient, request: networkRequest)
    }
    
    private static func request<V: Decodable>(
        client: NetworkClient,
        request: NetworkRequest
    ) async throws -> V {
        do {
            let (data, response) = try await client.data(for: try request.build())
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    return try JSONDecoder().decode(V.self, from: data)
                case 400...499:
                    throw NetworkError.client
                case 500...599:
                    throw NetworkError.server
                default:
                    throw NetworkError.unknown
                }
            }
            throw NetworkError.unknown
        } catch let error {
            throw error
        }
    }
}

extension NetworkManager {
    private final class DefaultNetworkClient: NetworkClient {
        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            try await URLSession.shared.data(for: request)
        }
    }
}
