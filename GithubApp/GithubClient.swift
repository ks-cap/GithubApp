import ComposableArchitecture
import Foundation

@DependencyClient
struct GithubClient {
    var fetchUsers: @Sendable (_ since: Int?) async throws -> [UserSummary]
}

extension GithubClient: DependencyKey {
    static let liveValue = Self(
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
            request.setValue("Bearer \(Secret.token)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([UserSummary].self, from: data)
        }
    )
}

extension DependencyValues {
    var githubClient: GithubClient {
        get { self[GithubClient.self] }
        set { self[GithubClient.self] = newValue }
    }
}

struct UserSummary: Codable, Equatable, Identifiable, Sendable {
    let id: Int
    let username: String
    let avatarImage: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarImage = "avatar_url"
    }
}

enum Secret {
    static let token = ""
}
