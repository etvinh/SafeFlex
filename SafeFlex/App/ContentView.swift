import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(DependencyContainer.self) private var container
    @State private var authScreen: AuthScreen = .welcome

    enum AuthScreen {
        case welcome, signIn, signUp
    }

    var body: some View {
        Group {
            if appState.isAuthenticated {
                if appState.needsOnboarding {
                    OnboardingView(
                        viewModel: OnboardingViewModel(
                            profiles: container.profiles,
                            recommender: container.recommender
                        ),
                        onComplete: {
                            withAnimation { appState.needsOnboarding = false }
                        }
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    MainTabView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            } else {
                authFlow
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appState.isAuthenticated)
    }

    @ViewBuilder
    private var authFlow: some View {
        switch authScreen {
        case .welcome:
            WelcomeView(
                onGetStarted: { withAnimation { authScreen = .signUp } },
                onSignIn: { withAnimation { authScreen = .signIn } }
            )
        case .signIn:
            SignInView(
                viewModel: AuthViewModel(auth: container.auth),
                onBack: { withAnimation { authScreen = .welcome } },
                onSuccess: signIn,
                onSignUp: { withAnimation { authScreen = .signUp } }
            )
        case .signUp:
            SignUpView(
                viewModel: AuthViewModel(auth: container.auth),
                onBack: { withAnimation { authScreen = .welcome } },
                onSuccess: signIn,
                onSignIn: { withAnimation { authScreen = .signIn } }
            )
        }
    }

    /// First-time users (no stored profile) get onboarding before the app.
    private func signIn(as user: User) {
        Task {
            appState.needsOnboarding = (try? await container.profiles.currentProfile()) == nil
            appState.signIn(as: user)
        }
    }
}
