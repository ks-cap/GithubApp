import Core
import Dependencies
import Foundation

public extension GithubClient {
    static func live(token: String?) -> GithubClient {
        let header: [String: String]
        if let token, !token.isEmpty {
            header = ["Authorization": "Bearer \(token)"]
        } else {
            header = [:]
        }

        return .init(
            fetchUsers: {
                let request = NetworkRequest(
                    urlString: "https://api.github.com/users",
                    httpMethod: .get,
                    header: header
                )
                return try await NetworkManager.request(request)
            }
        )
    }
}

public extension DependencyValues {
    var githubClient: GithubClient {
        get { self[GithubClient.self] }
        set { self[GithubClient.self] = newValue }
    }
}
