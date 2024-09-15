import Foundation

enum NetworkError: Error {
    case invalidUrl
    case client
    case server
    case unknown
}
