import SwiftUI

@Observable
class AppState {
    var isAuthenticated = false
    var activeTab: Tab = .dashboard
    var showLiveSession = false
    var showResults = false
    var showDeviceSettings = false
    var showPersonalInfo = false
    var showUploadProtocol = false
    var lastWorkout: Workout?
    var activeExercise = "Shoulder Abduction"
    var profileReturnTab: Tab = .dashboard
    var currentUser: User?
    var needsOnboarding = false

    enum Tab: String, CaseIterable {
        case dashboard, exercises, insights, profile
    }

    func signIn(as user: User) {
        currentUser = user
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = true
        }
    }

    func signOut() {
        currentUser = nil
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = false
            activeTab = .dashboard
        }
    }
}
