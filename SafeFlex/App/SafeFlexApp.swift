import SwiftUI

@main
struct SafeFlexApp: App {
    @State private var appState = AppState()
    @State private var container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(container)
                .task {
                    // Restore a persisted session so users stay signed in.
                    if let user = await container.auth.currentUser() {
                        appState.signIn(as: user)
                    }
                }
        }
    }
}
