import Foundation

/// Onboarding profile storage, scoped to the signed-in user.
protocol ProfileRepository: Sendable {
    /// The signed-in user's profile, or nil if onboarding hasn't run yet.
    func currentProfile() async throws -> UserProfile?
    func save(_ profile: UserProfile) async throws
}
