import Foundation

public struct UserSummary: Codable, Equatable, Identifiable, Sendable {
    public let id: Int
    public let username: String
    public let avatarImage: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarImage = "avatar_url"
    }
}
