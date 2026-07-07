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
                MainTabView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
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
                onSuccess: { appState.signIn(as: $0) },
                onSignUp: { withAnimation { authScreen = .signUp } }
            )
        case .signUp:
            SignUpView(
                viewModel: AuthViewModel(auth: container.auth),
                onBack: { withAnimation { authScreen = .welcome } },
                onSuccess: { appState.signIn(as: $0) },
                onSignIn: { withAnimation { authScreen = .signIn } }
            )
        }
    }
}
