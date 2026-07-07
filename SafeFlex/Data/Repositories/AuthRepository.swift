import Foundation

/// Abstraction the Authentication feature talks to; the Supabase
/// implementation lives next door and nothing outside Data/ knows it.
protocol AuthRepository: Sendable {
    /// Restores the persisted session, if any.
    func currentUser() async -> User?
    func signUp(email: String, password: String, fullName: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
}
