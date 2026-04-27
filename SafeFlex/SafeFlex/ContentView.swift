import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
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
                onBack: { withAnimation { authScreen = .welcome } },
                onSuccess: { appState.signIn() },
                onSignUp: { withAnimation { authScreen = .signUp } }
            )
        case .signUp:
            SignUpView(
                onBack: { withAnimation { authScreen = .welcome } },
                onSuccess: { appState.signIn() },
                onSignIn: { withAnimation { authScreen = .signIn } }
            )
        }
    }
}
