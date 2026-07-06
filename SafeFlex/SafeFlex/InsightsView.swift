import SwiftUI
import Charts

struct InsightsView: View {
    @Environment(AppState.self) private var appState
    @AppStorage("sensorAddress") private var serverAddress = "10.0.0.138:8080"
    @State private var report: InsightsReport?

    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    private var todayString: String {
        Date.now.formatted(.iso8601.year().month().day().dateSeparator(.dash))
    }

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Insights", left: { SafeFlexLogo() }, right: { AvatarView() })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Stats bento
                    HStack(spacing: 10) {
                        InsightStatCard(
                            icon: "chart.bar.fill", label: "Avg. Performance",
                            value: report?.performance.map { "\(Int($0.rounded()))%" } ?? "—",
                            sub: "this week", subColor: Theme.outline
                        )
                        InsightStatCard(
                            icon: "arrow.triangle.branch", label: "Total Reps",
                            value: report.map { "\($0.totalReps)" } ?? "—",
                            sub: "this week", subColor: Theme.outline
                        )
                    }
                    .padding(.bottom, 4)

                    dailyChartCard(
                        title: "Range of Motion",
                        subtitle: "Daily average across all exercises",
                        values: report?.days.map { ($0.weekday, $0.avgRomDegrees) } ?? [],
                        unit: "°", color: Theme.primary, maxY: 180
                    )

                    dailyChartCard(
                        title: "Stability",
                        subtitle: "Daily average across all exercises",
                        values: report?.days.map { ($0.weekday, $0.avgStabilityPercent) } ?? [],
                        unit: "%", color: Color(hex: "#16A34A"), maxY: 100
                    )

                    adherenceCard

                    therapistNoteCard

                    Spacer().frame(height: 96)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
        }
        .background(Theme.surface)
        .task { await load() }
        .onChange(of: appState.activeTab) { _, newTab in
            if newTab == .insights {
                Task { await load() }
            }
        }
    }

    private func load() async {
        report = await InsightsService.fetch(sensorAddress: serverAddress)
    }

    private func dailyChartCard(
        title: String, subtitle: String,
        values: [(String, Double?)],
        unit: String, color: Color, maxY: Double
    ) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Theme.onSurface)
                        Text(subtitle)
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.outline)
                    }
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.outline)
                }

                Chart {
                    ForEach(values, id: \.0) { weekday, value in
                        if let value {
                            BarMark(x: .value("Day", weekday), y: .value("Value", value))
                                .foregroundStyle(color.gradient)
                                .cornerRadius(4)
                        }
                    }
                }
                .chartXScale(domain: weekdays)
                .chartYScale(domain: 0...maxY)
                .chartYAxis {
                    AxisMarks(values: [0, maxY / 2, maxY]) { value in
                        AxisValueLabel {
                            Text("\(value.as(Int.self) ?? 0)\(unit)")
                                .font(.system(size: 8))
                                .foregroundStyle(Theme.outline)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: weekdays) { value in
                        AxisValueLabel {
                            let day = value.as(String.self) ?? ""
                            Text(day)
                                .font(.system(size: 9, weight: isToday(day) ? .bold : .regular))
                                .foregroundStyle(isToday(day) ? color : Theme.outline)
                        }
                    }
                }
                .frame(height: 96)
                .overlay {
                    if values.allSatisfy({ $0.1 == nil }) {
                        Text(report == nil ? "Server unreachable" : "No sessions yet this week")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.outline)
                    }
                }
            }
            .padding(15)
        }
        .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
    }

    private func isToday(_ weekday: String) -> Bool {
        report?.days.first(where: { $0.date == todayString })?.weekday == weekday
    }

    private var adherenceCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                Text("Adherence Log")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text("Prescribed exercises completed per day")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.outline)
                    .padding(.bottom, 12)

                if let report {
                    ForEach(weekdays, id: \.self) { weekday in
                        let entries = report.adherence.filter { $0.weekday == weekday }
                        if !entries.isEmpty {
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(spacing: 6) {
                                    Text(weekday)
                                        .font(.system(size: 11, weight: .heavy))
                                        .foregroundStyle(isToday(weekday) ? Theme.primary : Theme.secondary)
                                        .tracking(0.8)
                                    if isToday(weekday) {
                                        Text("TODAY")
                                            .font(.system(size: 8, weight: .heavy))
                                            .foregroundStyle(Theme.primary)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Theme.primary.opacity(0.09))
                                            .clipShape(Capsule())
                                    }
                                }
                                ForEach(entries, id: \.exercise) { entry in
                                    AdherenceRow(entry: entry)
                                }
                            }
                            .padding(.bottom, weekday == "Sun" ? 0 : 12)
                        }
                    }
                } else {
                    Text("Server unreachable")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.outline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
            .padding(15)
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

struct AdherenceRow: View {
    let entry: InsightsReport.AdherenceEntry

    private var color: Color {
        entry.percent >= 100 ? Color(hex: "#16A34A")
            : entry.percent > 0 ? Theme.primary
            : Theme.outline
    }

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(entry.exercise)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.onSurface)
                Spacer()
                Text("\(entry.completedReps)/\(entry.plannedReps) reps")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.outline)
                Text("\(Int(entry.percent.rounded()))%")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 38, alignment: .trailing)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.surfaceContainer).frame(height: 6)
                    Capsule().fill(color)
                        .frame(width: geo.size.width * CGFloat(entry.percent) / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
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
