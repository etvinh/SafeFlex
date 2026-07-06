import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        ZStack(alignment: .bottom) {
            TabView(selection: $appState.activeTab) {
                DashboardView()
                    .tag(AppState.Tab.dashboard)
                ExercisesView()
                    .tag(AppState.Tab.exercises)
                InsightsView()
                    .tag(AppState.Tab.insights)
                ProfileView()
                    .tag(AppState.Tab.profile)
            }
            .tabViewStyle(.automatic)
            .toolbar(.hidden, for: .tabBar)

            // Custom bottom nav
            HStack(spacing: 0) {
                ForEach(AppState.Tab.allCases.filter { $0 != .profile }, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isActive: appState.activeTab == tab,
                        action: { appState.activeTab = tab }
                    )
                }
            }
            .padding(.top, 10)
            .frame(height: 80)
            .background(.white.opacity(0.9))
            .background(.ultraThinMaterial)
            .clipShape(
                UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16)
            )
            .shadow(color: Theme.authAccent.opacity(0.04), radius: 10, y: -4)
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $appState.showLiveSession) {
            LiveSessionView()
        }
        .fullScreenCover(isPresented: $appState.showResults) {
            SessionResultsView()
        }
        .sheet(isPresented: $appState.showDeviceSettings) {
            DeviceSettingsView()
        }
        .sheet(isPresented: $appState.showPersonalInfo) {
            PersonalInfoView()
        }
        .sheet(isPresented: $appState.showUploadProtocol) {
            UploadProtocolView()
        }
    }
}

struct TabButton: View {
    let tab: AppState.Tab
    let isActive: Bool
    let action: () -> Void

    private var icon: String {
        switch tab {
        case .dashboard: "house.fill"
        case .exercises: "dumbbell.fill"
        case .insights: "chart.line.uptrend.xyaxis"
        case .profile: "person.fill"
        }
    }

    private var label: String {
        switch tab {
        case .dashboard: "Dashboard"
        case .exercises: "Exercises"
        case .insights: "Insights"
        case .profile: "Profile"
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(isActive ? Theme.primary : Color(hex: "#94A3B8"))
                Text(label)
                    .font(.system(size: 10, weight: isActive ? .bold : .medium))
                    .foregroundStyle(isActive ? Theme.primary : Color(hex: "#94A3B8"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(isActive ? Theme.primaryFixed.opacity(0.55) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity)
    }
}
