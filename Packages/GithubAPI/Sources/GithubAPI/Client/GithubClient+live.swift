import Core
import Dependencies
import Foundation

extension GithubClient {
    public static func live() -> GithubClient {
        .init(
            fetchUsers: {
                let components = URLComponents(string: "https://api.github.com/users")!
                var request = URLRequest(url: components.url!)
                request.httpMethod = "GET"
                request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    //            request.setValue("Bearer \(Secret.token)", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                return try JSONDecoder().decode([UserSummary].self, from: data)
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

enum Secret {
    static let token = ""
}
