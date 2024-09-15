import Foundation

protocol NetworkClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
