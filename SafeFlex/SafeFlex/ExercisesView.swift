import SwiftUI

struct ExercisesView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedSegment = "prescribed"

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(left: { SafeFlexLogo() }, right: { AvatarView() })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: 9) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.outline)
                        Text("Search exercises...")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.outline)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 44)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.outlineVariant, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
                    .padding(.bottom, 10)

                    // Segmented control
                    HStack(spacing: 0) {
                        ForEach(["prescribed", "library"], id: \.self) { seg in
                            Button {
                                withAnimation(.easeInOut(duration: 0.18)) { selectedSegment = seg }
                            } label: {
                                Text(seg == "prescribed" ? "Prescribed" : "Library")
                                    .font(.system(size: 12, weight: selectedSegment == seg ? .bold : .medium))
                                    .foregroundStyle(selectedSegment == seg ? Theme.primary : Theme.onSurfaceVariant)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(selectedSegment == seg ? .white : .clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .shadow(color: selectedSegment == seg ? .black.opacity(0.07) : .clear, radius: 1.5, y: 1)
                            }
                        }
                    }
                    .padding(3)
                    .background(Theme.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 16)

                    if selectedSegment == "prescribed" {
                        prescribedContent
                    } else {
                        libraryContent
                    }

                    Spacer().frame(height: 96)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
        }
        .background(Theme.surface)
    }

    private var prescribedContent: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Your Program")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(Theme.onSurface)
                    .tracking(-0.3)
                Spacer()
                Text("3 Total")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Theme.primary)
            }

            // Featured exercise
            GlassCard {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Shoulder Abduction")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundStyle(Theme.onSurface)
                                    .tracking(-0.3)
                                Text("UPPER BODY • RECOVERY")
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundStyle(Theme.outline)
                                    .tracking(0.9)
                            }
                            Spacer()
                            Text("TODAY")
                                .font(.system(size: 9, weight: .heavy))
                                .foregroundStyle(Theme.primary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Theme.primary.opacity(0.09))
                                .clipShape(Capsule())
                        }
                        .padding(.bottom, 11)

                        // Demo illustration
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(colors: [Color(hex: "#EFF6FF"), Color(hex: "#DBEAFE")],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 140)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Theme.primary.opacity(0.08), lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "figure.arms.open")
                                    .font(.system(size: 50))
                                    .foregroundStyle(Theme.primary.opacity(0.35))
                            )
                            .padding(.bottom, 11)

                        // Footer
                        HStack {
                            HStack(spacing: 22) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("SETS")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundStyle(Theme.secondary)
                                        .tracking(0.5)
                                    Text("3")
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundStyle(Theme.onSurface)
                                        .tracking(-0.5)
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("REPS")
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundStyle(Theme.secondary)
                                        .tracking(0.5)
                                    Text("12")
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundStyle(Theme.onSurface)
                                        .tracking(-0.5)
                                }
                            }
                            Spacer()
                            Button { appState.showLiveSession = true } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 11))
                                    Text("Start")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 18)
                                .frame(height: 36)
                                .background(Theme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .shadow(color: Theme.primary.opacity(0.3), radius: 5, y: 2)
                            }
                        }
                        .padding(.top, 10)
                        .overlay(alignment: .top) {
                            Divider().foregroundStyle(Theme.outlineVariant.opacity(0.4))
                        }
                    }
                    .padding(15)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.primary.opacity(0.1), lineWidth: 1)
            )

            // Other exercises
            ForEach([("Wrist Flexion", "2 Sets • 15 Reps"), ("Neck Stretch", "3 Sets • 30s Hold")], id: \.0) { name, meta in
                ExerciseRow(name: name, meta: meta) { appState.showLiveSession = true }
            }
        }
    }

    private var libraryContent: some View {
        VStack(spacing: 0) {
            HStack {
                Text("AI Recommended")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Theme.onSurface)
                Spacer()
                Button("Filter") {}
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.primary)
            }
            .padding(.bottom, 10)

            ForEach([
                ("Hip Abduction", "Mobility • Lower Body", "figure.walk"),
                ("Scapular Squeeze", "Posture • Upper Body", "figure.stand"),
                ("Bicep Curls", "Strength • Upper Body", "dumbbell.fill"),
                ("Quad Extension", "Strength • Lower Body", "figure.strengthtraining.traditional"),
            ], id: \.0) { name, cat, icon in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.surfaceLow)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 18))
                                .foregroundStyle(Theme.secondary)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Theme.onSurface)
                        Text(cat)
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.outline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.outline)
                }
                .padding(.horizontal, 14)
                .frame(height: 68)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.outlineVariant.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
                .padding(.bottom, 8)
            }
        }
    }
}

struct ExerciseRow: View {
    var name: String
    var meta: String
    var onStart: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#EFF6FF"))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.primary)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text(meta)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary)
            }
            Spacer()
            Button("Start", action: onStart)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Theme.primary)
                .padding(.horizontal, 12)
                .frame(height: 30)
                .background(Theme.surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 14)
        .frame(height: 72)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.outlineVariant.opacity(0.55), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
    }
}
