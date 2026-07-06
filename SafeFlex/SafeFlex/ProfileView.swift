import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Profile", left: {
                Button {
                    appState.activeTab = appState.profileReturnTab
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(Theme.primary)
                }
            }, right: { AvatarView() })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // User header
                    HStack(spacing: 14) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#DBEAFE"), Color(hex: "#EFF6FF")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 72, height: 72)
                                .overlay(Circle().stroke(Theme.primary, lineWidth: 2))
                                .overlay(
                                    Text("SJ")
                                        .font(.system(size: 26, weight: .heavy))
                                        .foregroundStyle(Theme.primary)
                                )

                            Circle()
                                .fill(Theme.primary)
                                .frame(width: 22, height: 22)
                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                .overlay(
                                    Image(systemName: "pencil")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sarah Jenkins")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Theme.onSurface)
                                .tracking(-0.4)
                            Text("Patient ID: SF-8829-X")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.secondary)
                        }
                        Spacer()
                    }

                    // Account Settings
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "ACCOUNT SETTINGS")
                        ProfileSettingsGroup {
                            ProfileRow(icon: "person.fill", title: "Personal Information") {
                                appState.showPersonalInfo = true
                            }
                            Divider().padding(.horizontal, 16)
                            ProfileRow(icon: "bell.fill", title: "Notification Preferences") {}
                        }
                    }

                    // Health & Privacy
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "HEALTH & PRIVACY")
                        ProfileSettingsGroup {
                            HealthKitToggleRow()
                            Divider().padding(.horizontal, 16)
                            ProfileRow(icon: "lock.fill", title: "Privacy & Data Sharing",
                                       iconBg: Color(hex: "#FFDBCD").opacity(0.5), iconColor: Theme.tertiary) {}
                        }
                    }

                    // Device Settings
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "DEVICE SETTINGS")
                        deviceSettingsCard
                    }

                    // Care Team
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "CARE TEAM")
                        careTeamCard
                    }

                    // Sign Out
                    Button {
                        appState.signOut()
                    } label: {
                        Text("Sign Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.error)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.error.opacity(0.2), lineWidth: 1)
                            )
                    }

                    Text("SafeFlex App v4.2.1-stable")
                        .font(.system(size: 10))
                        .foregroundStyle(Theme.outline)

                    Spacer().frame(height: 96)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .background(Theme.surface)
    }

    private var deviceSettingsCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Theme.surfaceHighest)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "applewatch")
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.primary)
                    )
                VStack(alignment: .leading, spacing: 1) {
                    Text("SafeFlex Band v2")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.onSurface)
                    Text("Connected • 84% Battery")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Theme.primary)
                }
                Spacer()
                Button { appState.showDeviceSettings = true } label: {
                    Text("Manage")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.primary)
                        .padding(.horizontal, 12)
                        .frame(height: 32)
                        .background(Theme.surfaceContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.primary.opacity(0.18), lineWidth: 1)
                        )
                }
            }

            HStack(spacing: 7) {
                Image(systemName: "info.circle")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.outline)
                Text("Last synchronized: Today at 9:41 AM")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.secondary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.white.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(16)
        .background(Theme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.outlineVariant.opacity(0.3), lineWidth: 1)
        )
    }

    private var careTeamCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "#DBEAFE"), Color(hex: "#EFF6FF")],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 44, height: 44)
                .overlay(
                    Circle().stroke(Theme.outlineVariant.opacity(0.4), lineWidth: 1)
                )
                .overlay(
                    Text("MC")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(Theme.primary)
                )
            VStack(alignment: .leading, spacing: 1) {
                Text("Dr. Michael Chen")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text("Lead Physical Therapist")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                ForEach(["message.fill", "phone.fill"], id: \.self) { icon in
                    Circle()
                        .fill(Theme.primaryFixed.opacity(0.5))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.primary)
                        )
                }
            }
        }
        .padding(16)
        .background(Theme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.outlineVariant.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ProfileSettingsGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Theme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.outlineVariant.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ProfileRow: View {
    var icon: String
    var title: String
    var iconBg: Color = Theme.primaryFixed.opacity(0.5)
    var iconColor: Color = Theme.primary
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconBg)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(iconColor)
                    )
                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.onSurface)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.outline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

struct HealthKitToggleRow: View {
    @State private var isEnabled = true

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#FFDBCD").opacity(0.5))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.tertiary)
                )
            VStack(alignment: .leading, spacing: 1) {
                Text("Apple HealthKit Sync")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.onSurface)
                Text("Sync your recovery metrics")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary)
            }
            Spacer()
            Toggle("", isOn: $isEnabled)
                .tint(Theme.primary)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}
