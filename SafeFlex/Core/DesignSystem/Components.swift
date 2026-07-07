import SwiftUI

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 14
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(.white.opacity(0.72))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
    }
}

struct SafeFlexLogo: View {
    var body: some View {
        Text("SafeFlex")
            .font(.system(size: 18, weight: .heavy))
            .foregroundStyle(Color(hex: "#1D4ED8"))
            .tracking(-0.5)
    }
}

struct AvatarView: View {
    @Environment(AppState.self) private var appState
    var initials: String = "SJ"
    var size: CGFloat = 32

    var body: some View {
        Button {
            if appState.activeTab != .profile {
                appState.profileReturnTab = appState.activeTab
                appState.activeTab = .profile
            }
        } label: {
            Circle()
                .fill(Theme.primaryFixed)
                .overlay(
                    Circle().stroke(Theme.primaryFixedDim, lineWidth: 1.5)
                )
                .overlay(
                    Text(initials)
                        .font(.system(size: size * 0.33, weight: .heavy))
                        .foregroundStyle(Theme.primary)
                )
                .frame(width: size, height: size)
        }
    }
}

struct TopBarView<Left: View, Right: View>: View {
    var title: String?
    @ViewBuilder var left: () -> Left
    @ViewBuilder var right: () -> Right

    var body: some View {
        HStack {
            left()
            Spacer()
            if let title {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
            }
            Spacer()
            right()
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(.white.opacity(0.8))
        .background(.ultraThinMaterial)
    }
}

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                Text("Back")
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(Theme.primary)
        }
    }
}

struct ShieldIcon: View {
    var size: CGFloat = 22

    var body: some View {
        Image(systemName: "cross.case.fill")
            .font(.system(size: size))
            .foregroundStyle(.white)
    }
}

struct SectionHeader: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Theme.onSurfaceVariant)
            .tracking(0.6)
            .padding(.leading, 2)
    }
}
