import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct GithubClient: Sendable {
    public var fetchUsers: @Sendable () async throws -> [User]
}

extension GithubClient: TestDependencyKey {
    public static var previewValue: Self {
        .init(
            fetchUsers: {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                return (0 ..< 20).map { .mock(id: $0, userName: "MockUser\($0)") }
            }
        )
    }

    public static var testValue = Self.init(
        fetchUsers: {
            (0 ..< 20).map { .mock(id: $0, userName: "MockUser\($0)") }
        }
    )
}

extension DependencyValues {
    public var githubClient: GithubClient {
        get { self[GithubClient.self] }
        set { self[GithubClient.self] = newValue }
    }
}

public extension User {
    static func mock(
        id: Int = 1,
        userName: String = "MockUser01",
        avatarUrlString: String = "https://placehold.jp/150x150.png"
    ) -> Self {
        .init(id: id, userName: userName, avatarUrlString: avatarUrlString)
    }
}
