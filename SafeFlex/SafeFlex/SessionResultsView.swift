import SwiftUI
import Charts

struct SessionResultsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false

    private let metrics: [(label: String, value: String, sub: String, color: Color, bg: Color)] = [
        ("Total Reps", "36", "3 sets completed", Theme.primary, Color(hex: "#EFF6FF")),
        ("Avg. ROM", "112°", "+8° improvement", Color(hex: "#15803D"), Color(hex: "#F0FDF4")),
        ("Stability", "94%", "High precision", Color(hex: "#15803D"), Color(hex: "#F0FDF4")),
        ("Pain Delta", "−2.5", "Decreased intensity", Color(hex: "#B45309"), Color(hex: "#FFFBEB")),
    ]

    private let romPoints: [Double] = [78, 82, 88, 90, 95, 100, 102, 108, 104, 112, 110, 118]
    private let stabPoints: [Double] = [76, 80, 86, 84, 88, 91, 89, 94, 91, 95, 93, 96]

    var body: some View {
        VStack(spacing: 0) {
            // App bar
            HStack {
                HStack(spacing: 9) {
                    Circle()
                        .fill(Theme.primary)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text("SJ")
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundStyle(.white)
                        )
                    Text("SafeFlex")
                        .font(.system(size: 17, weight: .heavy))
                        .foregroundStyle(Theme.primary)
                        .tracking(-0.4)
                }
                Spacer()
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color(hex: "#15803D"))
                    Text("SESSION COMPLETE")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(Color(hex: "#15803D"))
                        .tracking(0.8)
                }
                .padding(.horizontal, 9)
                .frame(height: 22)
                .background(Color(hex: "#F0FDF4"))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color(hex: "#BBF7D0"), lineWidth: 1))
            }
            .padding(.horizontal, 18)
            .frame(height: 64)
            .background(.white.opacity(0.82))
            .background(.ultraThinMaterial)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Session Results")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(Theme.onSurface)
                        .tracking(-0.5)
                    Text("Shoulder Abduction • \(Date.now.formatted(.dateTime.month(.abbreviated).day().year()))")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.secondary)
                        .padding(.top, 3)
                        .padding(.bottom, 16)

                    // Metrics grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible())], spacing: 8) {
                        ForEach(Array(metrics.enumerated()), id: \.offset) { _, metric in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(metric.label)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(Theme.secondary)
                                    .tracking(0.6)
                                    .textCase(.uppercase)
                                Text(metric.value)
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundStyle(metric.color)
                                    .tracking(-0.8)
                                Text(metric.sub)
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.secondary)
                                    .padding(.top, 1)
                            }
                            .padding(13)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(metric.bg)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                        }
                    }
                    .padding(.bottom, 16)

                    // ROM chart
                    ResultChartCard(
                        title: "Range of Motion (ROM)",
                        badge: "Peak: 118°",
                        badgeColor: Theme.primary,
                        badgeBg: Color(hex: "#EFF6FF"),
                        data: romPoints,
                        lineColor: Theme.primary,
                        yLow: "78°",
                        yHigh: "118°"
                    )

                    // Stability chart
                    ResultChartCard(
                        title: "Stability Score",
                        badge: "Target: >90%",
                        badgeColor: Color(hex: "#15803D"),
                        badgeBg: Color(hex: "#F0FDF4"),
                        data: stabPoints,
                        lineColor: Color(hex: "#16A34A"),
                        yLow: "75%",
                        yHigh: "96%"
                    )

                    // Actions
                    VStack(spacing: 9) {
                        Button { showShareSheet = true } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 13))
                                Text("Share with PT")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Theme.primary.opacity(0.3), radius: 6, y: 2)
                        }

                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Theme.primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.primary.opacity(0.22), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.surface)
        .sheet(isPresented: $showShareSheet) {
            ShareResultsSheet()
        }
    }
}

struct ResultChartCard: View {
    var title: String
    var badge: String
    var badgeColor: Color
    var badgeBg: Color
    var data: [Double]
    var lineColor: Color
    var yLow: String
    var yHigh: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Spacer()
                Text(badge)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(badgeColor)
                    .padding(.horizontal, 8)
                    .frame(height: 20)
                    .background(badgeBg)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 9)

            HStack {
                ForEach(["Rep 1", "Rep 4", "Rep 8", "Rep 12"], id: \.self) { label in
                    Text(label)
                        .font(.system(size: 8))
                        .foregroundStyle(Theme.outline)
                    if label != "Rep 12" { Spacer() }
                }
            }
            .padding(.bottom, 3)

            Chart {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    AreaMark(x: .value("Rep", index), y: .value("Value", value))
                        .foregroundStyle(
                            LinearGradient(colors: [lineColor.opacity(0.18), lineColor.opacity(0)],
                                           startPoint: .top, endPoint: .bottom)
                        )
                    LineMark(x: .value("Rep", index), y: .value("Value", value))
                        .foregroundStyle(lineColor)
                        .lineStyle(StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
                }
                if let maxVal = data.max(), let maxIdx = data.firstIndex(of: maxVal) {
                    PointMark(x: .value("Rep", maxIdx), y: .value("Value", maxVal))
                        .foregroundStyle(lineColor)
                        .symbolSize(40)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 68)

            HStack {
                Text(yLow)
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.outline)
                Spacer()
                Text(yHigh)
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.outline)
            }
            .padding(.top, 3)
        }
        .padding(13)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(Theme.outlineVariant.opacity(0.5), lineWidth: 1)
        )
        .padding(.bottom, 10)
    }
}

struct ShareResultsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sent = false

    private let providers = ["Dr. Emily Chen (PT)", "Dr. Marcus Williams", "Memorial PT Clinic"]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.outlineVariant)
                .frame(width: 34, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)

            if !sent {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Share Results")
                        .font(.system(size: 17, weight: .heavy))
                        .foregroundStyle(Theme.onSurface)
                    Text("Select your provider to receive this session report.")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondary)
                        .padding(.top, 3)
                        .padding(.bottom, 14)

                    ForEach(providers, id: \.self) { provider in
                        Button { sent = true } label: {
                            HStack(spacing: 11) {
                                Circle()
                                    .fill(Color(hex: "#DBEAFE"))
                                    .frame(width: 34, height: 34)
                                    .overlay(
                                        Text(String(provider.dropFirst(4).prefix(1)))
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundStyle(Theme.primary)
                                    )
                                Text(provider)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Theme.onSurface)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(Theme.outline)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            .background(Color(hex: "#F8FAFF"))
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(Theme.primary.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .padding(.bottom, 8)
                    }

                    Button("Cancel") { dismiss() }
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 18)
            } else {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color(hex: "#F0FDF4"))
                        .frame(width: 58, height: 58)
                        .overlay(Circle().stroke(Color(hex: "#BBF7D0"), lineWidth: 2))
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Theme.success)
                        )
                        .padding(.bottom, 12)

                    Text("Report Sent!")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(Theme.onSurface)
                        .padding(.bottom, 5)

                    Text("Your PT will receive your session results shortly.")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.bottom, 20)

                    Button { dismiss() } label: {
                        Text("Done")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .frame(height: 46)
                            .background(Theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
            }

            Spacer()
        }
        .presentationDetents([.medium])
    }
}
