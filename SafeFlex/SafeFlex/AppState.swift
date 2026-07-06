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

    enum Tab: String, CaseIterable {
        case dashboard, exercises, insights, profile
    }

    func signIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = true
        }
    }

    func signOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isAuthenticated = false
            activeTab = .dashboard
        }
    }
}
