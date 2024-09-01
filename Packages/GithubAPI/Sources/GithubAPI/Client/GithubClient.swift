import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct GithubClient: Sendable {
    public var fetchUsers: @Sendable (_ since: Int?) async throws -> [UserSummary]
}

extension GithubClient: DependencyKey {
    public static let liveValue = Self(
        fetchUsers: { since in
            var components = URLComponents(string: "https://api.github.com/users")!
            if let since {
                components.queryItems = [
                    .init(name: "since", value: "\(since)")
                ]
            }
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
//            request.setValue("Bearer \(Secret.token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([UserSummary].self, from: data)
        }
    )
}

extension DependencyValues {
    public var githubClient: GithubClient {
        get { self[GithubClient.self] }
        set { self[GithubClient.self] = newValue }
    }
}

enum Secret {
    static let token = ""
}
