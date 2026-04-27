import SwiftUI
import Charts

struct InsightsView: View {
    @Environment(AppState.self) private var appState

    private let romData: [(Int, Double)] = [
        (0, 72), (1, 78), (2, 82), (3, 80), (4, 88), (5, 92), (6, 90),
        (7, 98), (8, 95), (9, 102), (10, 100), (11, 108), (12, 105), (13, 112),
    ]

    private let heatmapValues: [Double] = [
        1, 0.2, 1, 1, 0.6, 0.2, 1,
        0.8, 1, 1, 0.2, 1, 0.6, 1,
        1, 0.2, 0.8, 1, 1, 0.4, 1,
        0.6, 1, 1, 0.2, 1, 0.8, 0,
    ]

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Insights", left: { SafeFlexLogo() }, right: { AvatarView() })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Stats bento
                    HStack(spacing: 10) {
                        InsightStatCard(icon: "chart.bar.fill", label: "Avg. Performance",
                                        value: "94%", sub: "+2.4%", subColor: Theme.tertiary)
                        InsightStatCard(icon: "arrow.triangle.branch", label: "Total Reps",
                                        value: "1,248", sub: "this month", subColor: Theme.outline)
                    }
                    .padding(.bottom, 4)

                    // ROM Chart
                    romChartCard

                    // Stability + Adherence row
                    HStack(spacing: 10) {
                        stabilityCard
                        adherenceCard
                    }

                    // Therapist note
                    therapistNoteCard

                    Spacer().frame(height: 96)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
        }
        .background(Theme.surface)
    }

    private var romChartCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Range of Motion")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Theme.onSurface)
                        Text("Progress over the last 14 days")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.outline)
                    }
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.outline)
                }

                Chart {
                    ForEach(romData, id: \.0) { index, value in
                        AreaMark(
                            x: .value("Day", index),
                            y: .value("ROM", value)
                        )
                        .foregroundStyle(
                            LinearGradient(colors: [Theme.primary.opacity(0.12), Theme.primary.opacity(0)],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        LineMark(
                            x: .value("Day", index),
                            y: .value("ROM", value)
                        )
                        .foregroundStyle(Theme.primary)
                        .lineStyle(StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                    }
                    PointMark(x: .value("Day", 13), y: .value("ROM", 112))
                        .foregroundStyle(Theme.primary)
                        .symbolSize(50)
                }
                .chartYScale(domain: 60...120)
                .chartYAxis {
                    AxisMarks(values: [30, 60, 90, 120]) { value in
                        AxisValueLabel {
                            Text("\(value.as(Int.self) ?? 0)°")
                                .font(.system(size: 8))
                                .foregroundStyle(Theme.outline)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: [0, 2, 4, 6, 8, 10, 13]) { value in
                        AxisValueLabel {
                            let labels = ["Mon", "Wed", "Fri", "Sun", "Tue", "Thu", "Today"]
                            let idx = [0, 2, 4, 6, 8, 10, 13].firstIndex(of: value.as(Int.self) ?? 0) ?? 0
                            Text(labels[idx])
                                .font(.system(size: 9, weight: idx == 6 ? .bold : .regular))
                                .foregroundStyle(idx == 6 ? Theme.primary : Theme.outline)
                        }
                    }
                }
                .frame(height: 72)
            }
            .padding(15)
        }
        .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
    }

    private var stabilityCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                Text("Stability")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text("Balance & control")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.outline)
                    .padding(.bottom, 12)

                StabilityBar(label: "Knee Stability", percent: 85, color: Theme.primary)
                    .padding(.bottom, 10)
                StabilityBar(label: "Joint Load", percent: 92, color: Theme.tertiary)
            }
            .padding(14)
        }
        .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
    }

    private var adherenceCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                Text("Adherence")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text("Last 28 days")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.outline)
                    .padding(.bottom, 10)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                    ForEach(Array(heatmapValues.enumerated()), id: \.offset) { _, value in
                        Rectangle()
                            .fill(value > 0.5
                                  ? Theme.primary.opacity(value)
                                  : value > 0 ? Theme.primary.opacity(value + 0.1) : Theme.surfaceHigh)
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                            .overlay(
                                value == 0
                                ? RoundedRectangle(cornerRadius: 2)
                                    .stroke(Theme.outlineVariant.opacity(0.4), lineWidth: 1)
                                : nil
                            )
                    }
                }

                HStack {
                    Text("Less")
                        .font(.system(size: 8))
                        .foregroundStyle(Theme.outline)
                    Spacer()
                    HStack(spacing: 3) {
                        ForEach([0.15, 0.35, 0.65, 1.0], id: \.self) { opacity in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.primary.opacity(opacity))
                                .frame(width: 8, height: 8)
                        }
                    }
                    Spacer()
                    Text("More")
                        .font(.system(size: 8))
                        .foregroundStyle(Theme.outline)
                }
                .padding(.top, 8)
            }
            .padding(14)
        }
        .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
    }

    private var therapistNoteCard: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Theme.primary.opacity(0.1))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "doc.text")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.primary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Therapist Recommendation")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.primary)
                Text("\"Great improvement in knee flexion. Focus on slow eccentric movements for the next 48 hours to manage load.\"")
                    .font(.system(size: 13).italic())
                    .foregroundStyle(Theme.onSurfaceVariant)
                    .lineSpacing(4)
            }
        }
        .padding(15)
        .background(Theme.primaryFixed.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.primary.opacity(0.12), lineWidth: 1)
        )
    }
}

struct InsightStatCard: View {
    var icon: String
    var label: String
    var value: String
    var sub: String
    var subColor: Color

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.primary)
                    Text(label)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Theme.outline)
                        .tracking(0.7)
                        .textCase(.uppercase)
                }
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text(value)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundStyle(Theme.primary)
                        .tracking(-1)
                    Text(sub)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(subColor)
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
    }
}

struct StabilityBar: View {
    var label: String
    var percent: Int
    var color: Color

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.onSurface)
                Spacer()
                Text("\(percent)%")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.surfaceContainer).frame(height: 6)
                    Capsule().fill(color)
                        .frame(width: geo.size.width * CGFloat(percent) / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}
