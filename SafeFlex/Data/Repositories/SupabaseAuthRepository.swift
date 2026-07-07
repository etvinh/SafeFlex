import Foundation
import Supabase

struct SupabaseAuthRepository: AuthRepository {
    private var client: SupabaseClient { .shared }

    func currentUser() async -> User? {
        guard let session = try? await client.auth.session else { return nil }
        return Self.map(session.user)
    }

    func signUp(email: String, password: String, fullName: String) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password,
            data: ["full_name": .string(fullName)]
        )
        guard let session = response.session else {
            // Hosted projects can require email confirmation before a session exists.
            throw AuthUIError("Check your inbox to confirm your email, then sign in.")
        }
        return Self.map(session.user)
    }

    func signIn(email: String, password: String) async throws -> User {
        do {
            let session = try await client.auth.signIn(email: email, password: password)
            return Self.map(session.user)
        } catch let error as AuthError {
            let message = error.message.localizedCaseInsensitiveContains("credentials")
                ? "Invalid email or password."
                : error.message
            throw AuthUIError(message)
        } catch is URLError {
            throw AuthUIError("Can't reach the server. Is it running?")
        }
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    private static func map(_ user: Auth.User) -> User {
        User(
            id: user.id,
            email: user.email,
            fullName: user.userMetadata["full_name"]?.stringValue,
            authProvider: user.appMetadata["provider"]?.stringValue ?? "email"
        )
    }

}

/// Error whose description is safe to show directly in the UI.
struct AuthUIError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}
