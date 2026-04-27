import SwiftUI

struct DeviceSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var autoSync = true

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Device hero
                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 5) {
                                    Circle()
                                        .fill(Color(hex: "#16A34A"))
                                        .frame(width: 6, height: 6)
                                    Text("Active")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(Color(hex: "#15803D"))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color(hex: "#F0FDF4"))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color(hex: "#BBF7D0"), lineWidth: 1))

                                Text("SafeFlex Band v2")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Theme.onSurface)
                                    .tracking(-0.3)
                                Text("Bluetooth LE Connected")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.secondary)
                            }
                            Spacer()
                            BatteryRing(percent: 84)
                        }
                        .padding(16)
                    }

                    // Device Actions
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "DEVICE ACTIONS")
                        GlassCard {
                            VStack(spacing: 0) {
                                DeviceActionRow(icon: "arrow.triangle.branch", title: "Recalibrate Sensors",
                                                subtitle: "Adjust accuracy for therapy")
                                Divider().padding(.horizontal, 16)
                                DeviceActionRow(icon: "chart.xyaxis.line", title: "Firmware Update",
                                                subtitle: "v2.4.1 Stable available", badge: "NEW")
                            }
                        }
                    }

                    // Connectivity
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "CONNECTIVITY")
                        GlassCard {
                            VStack(spacing: 0) {
                                HStack(spacing: 14) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Theme.primary.opacity(0.08))
                                        .frame(width: 38, height: 38)
                                        .overlay(
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                .font(.system(size: 16))
                                                .foregroundStyle(Theme.primary)
                                        )
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Auto-Sync Data")
                                            .font(.system(size: 15))
                                            .foregroundStyle(Theme.onSurface)
                                        Text("Real-time clinical updates")
                                            .font(.system(size: 11))
                                            .foregroundStyle(Theme.secondary)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $autoSync)
                                        .tint(Theme.primary)
                                        .labelsHidden()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)

                                Divider().padding(.horizontal, 16)

                                HStack(spacing: 14) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Theme.error.opacity(0.08))
                                        .frame(width: 38, height: 38)
                                        .overlay(
                                            Image(systemName: "link.badge.plus")
                                                .font(.system(size: 16))
                                                .foregroundStyle(Theme.error)
                                        )
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Disconnect Device")
                                            .font(.system(size: 15))
                                            .foregroundStyle(Theme.error)
                                        Text("Unpair from this smartphone")
                                            .font(.system(size: 11))
                                            .foregroundStyle(Theme.error.opacity(0.6))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Theme.error.opacity(0.35))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)
                            }
                        }
                    }

                    // Technical Details
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "TECHNICAL DETAILS")
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible())], spacing: 10) {
                            TechDetailCard(label: "Serial Number", value: "SF-2024-9982-A", isMono: true)
                            TechDetailCard(label: "Hardware Rev", value: "REV_E_04", isMono: true)
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FDA Compliance")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.onSurfaceVariant)
                                Text("Class II Therapeutic Device")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.onSurface)
                            }
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Theme.primary.opacity(0.35))
                        }
                        .padding(13)
                        .background(Theme.surfaceLow)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.surfaceHighest, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Theme.surface)
            .navigationTitle("Device Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.primary)
                }
            }
        }
    }
}

struct BatteryRing: View {
    var percent: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.surfaceContainer, lineWidth: 4)
                .frame(width: 52, height: 52)
            Circle()
                .trim(from: 0, to: CGFloat(percent) / 100)
                .stroke(Theme.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 52, height: 52)
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("\(percent)%")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(Theme.onSurface)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.primary)
            }
        }
    }
}

struct DeviceActionRow: View {
    var icon: String
    var title: String
    var subtitle: String
    var badge: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Theme.primary.opacity(0.08))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.primary)
                )
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 7) {
                    Text(title)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.onSurface)
                    if let badge {
                        Text(badge)
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Theme.primaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Theme.outline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}

struct TechDetailCard: View {
    var label: String
    var value: String
    var isMono: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Theme.onSurfaceVariant)
            Text(value)
                .font(isMono ? .system(size: 13, weight: .bold, design: .monospaced) : .system(size: 13, weight: .bold))
                .foregroundStyle(Theme.onSurface)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(Theme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.surfaceHighest, lineWidth: 1)
        )
    }
}
