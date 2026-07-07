import SwiftUI

struct DashboardView: View {
    @Environment(AppState.self) private var appState

    private let days: [(label: String, done: Bool, num: Int, isToday: Bool)] = [
        ("Mon", true, 21, false), ("Tue", true, 22, false),
        ("Wed", false, 23, true), ("Thu", false, 24, false),
        ("Fri", false, 25, false), ("Sat", false, 26, false),
        ("Sun", false, 27, false),
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                TopBarView(left: { SafeFlexLogo() }, right: { AvatarView() })

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        // Greeting
                        VStack(alignment: .leading, spacing: 2) {
                            Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Theme.secondary)
                                .tracking(0.9)
                                .textCase(.uppercase)
                            Text("Hello, Sarah")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundStyle(Theme.onSurface)
                                .tracking(-0.7)
                        }
                        .padding(.bottom, 4)

                        // Sensor Status
                        GlassCard {
                            HStack(spacing: 13) {
                                Circle()
                                    .fill(Theme.primaryFixed)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "antenna.radiowaves.left.and.right")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Theme.primary)
                                    )
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Sensor Status")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(Theme.onSurface)
                                    Text("SafeFlex Band v2 Connected")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Theme.secondary)
                                }
                                Spacer()
                                HStack(spacing: 5) {
                                    Circle()
                                        .fill(Theme.success)
                                        .frame(width: 7, height: 7)
                                        .shadow(color: Theme.success.opacity(0.7), radius: 3)
                                    Text("Active")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(Theme.primary)
                                }
                            }
                            .padding(15)
                        }

                        // Today's Plan
                        todaysPlanCard

                        // Weekly Adherence
                        weeklyAdherenceCard

                        Spacer().frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .background(Theme.surface)

            // FAB
            Button {
                appState.activeExercise = "Shoulder Abduction"
                appState.showLiveSession = true
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 14))
                    Text("Start Session")
                        .font(.system(size: 13, weight: .bold))
                        .tracking(-0.2)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Theme.primary)
                .clipShape(Capsule())
                .shadow(color: Theme.primary.opacity(0.45), radius: 10, y: 4)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 90)
        }
    }

    private var todaysPlanCard: some View {
        GlassCard {
            VStack(spacing: 0) {
                // Hero gradient
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [Color(hex: "#1E3A6E"), Color(hex: "#1D4ED8")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 128)

                    Image(systemName: "figure.arms.open")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 16)

                    LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
                        .frame(height: 50)
                        .frame(maxHeight: .infinity, alignment: .bottom)

                    Text("RECOMMENDED")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(.white)
                        .tracking(0.8)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Theme.primary)
                        .clipShape(Capsule())
                        .padding(14)
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 14, topTrailingRadius: 14))

                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Today's Plan")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Theme.onSurface)
                            Text("Focus: Shoulder Stability")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("0%")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundStyle(Theme.primary)
                                .tracking(-1)
                            Text("Complete")
                                .font(.system(size: 9))
                                .foregroundStyle(Theme.secondary)
                        }
                    }

                    // Exercise row
                    HStack(spacing: 11) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(width: 34, height: 34)
                            .shadow(color: .black.opacity(0.06), radius: 1.5, y: 1)
                            .overlay(
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Theme.primary)
                            )
                        VStack(alignment: .leading, spacing: 1) {
                            Text("External Rotation")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Theme.onSurface)
                            Text("3 Sets × 12 Reps")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Theme.outline)
                    }
                    .padding(13)
                    .background(Theme.surfaceLow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.outlineVariant.opacity(0.3), lineWidth: 1)
                    )

                    // Progress bar
                    GeometryReader { geo in
                        Capsule().fill(Theme.surfaceContainer)
                            .frame(height: 4)
                    }
                    .frame(height: 4)
                }
                .padding(15)
            }
        }
    }

    private var weeklyAdherenceCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Weekly Adherence")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.onSurface)

                HStack {
                    ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(day.done ? Theme.primary :
                                            day.isToday ? Theme.primaryFixed : Theme.surfaceContainer)
                                    .frame(width: 36, height: 36)
                                    .shadow(color: day.done ? Theme.primary.opacity(0.28) : .clear, radius: 3, y: 2)

                                if day.isToday {
                                    Circle()
                                        .stroke(Theme.primary, lineWidth: 2)
                                        .frame(width: 36, height: 36)
                                }

                                if day.done {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("\(day.num)")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(day.isToday ? Theme.primary : Theme.outline)
                                }
                            }
                            .opacity(!day.done && !day.isToday ? 0.45 : 1)

                            Text(day.label)
                                .font(.system(size: 9, weight: day.isToday ? .bold : .medium))
                                .foregroundStyle(day.isToday ? Theme.primary : Theme.secondary)
                                .textCase(.uppercase)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(15)
        }
    }
}

