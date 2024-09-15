import Foundation

public struct User: Decodable, Equatable, Identifiable, Sendable {
    public let id: Int
    public let userName: String
    public let avatarUrlString: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userName = "login"
        case avatarUrlString = "avatar_url"
    }
    
    public var avatarUrl: URL {
        .init(string: avatarUrlString)!
    }
}
