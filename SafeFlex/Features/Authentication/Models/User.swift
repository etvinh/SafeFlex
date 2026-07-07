import Foundation

struct User: Codable, Sendable {
    let id: UUID
    let email: String?
    let fullName: String?
    let authProvider: String
}
