import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    var isLoading = false
    var errorMessage = ""

    private let auth: AuthRepository

    init(auth: AuthRepository) {
        self.auth = auth
    }

    func signIn(email: String, password: String) async -> User? {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return nil
        }
        return await run { try await auth.signIn(email: email, password: password) }
    }

    func signUp(name: String, email: String, password: String) async -> User? {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return nil
        }
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters."
            return nil
        }
        return await run { try await auth.signUp(email: email, password: password, fullName: name) }
    }

    func appleSignInUnavailable() {
        errorMessage = "Sign in with Apple needs the paid Apple Developer capability — use email for now."
    }

    private func run(_ operation: () async throws -> User) async -> User? {
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }
        do {
            return try await operation()
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
