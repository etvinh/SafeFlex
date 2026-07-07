import Foundation

/// Pure computation of the weekly insights report from raw workouts —
/// no I/O, so it is directly unit-testable.
enum InsightsCalculator {
    static let weekdayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    /// Performance blends joint control and achieved range: stability is
    /// already a percentage; ROM is normalized against the 180° full range.
    static func performanceScore(rom: Double, stability: Double) -> Double {
        round1(0.5 * stability + 0.5 * (rom / SensorScale.romFullRangeDegrees * 100))
    }

    /// Monday-based week containing `today`.
    static func weekDates(containing today: Date = .now) -> [Date] {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .current
        let start = calendar.startOfDay(for: today)
        let daysSinceMonday = (calendar.component(.weekday, from: start) + 5) % 7
        return (0..<7).map {
            calendar.date(byAdding: .day, value: $0 - daysSinceMonday, to: start)!
        }
    }

    static func report(from workouts: [Workout], today: Date = .now) -> InsightsReport {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dates = weekDates(containing: today)

        var byDay: [String: [Workout]] = [:]
        for workout in workouts {
            byDay[formatter.string(from: workout.endedAt), default: []].append(workout)
        }

        var days: [InsightsReport.Day] = []
        var adherence: [InsightsReport.AdherenceEntry] = []
        for (index, date) in dates.enumerated() {
            let dateString = formatter.string(from: date)
            let weekday = weekdayNames[index]
            let dayWorkouts = byDay[dateString] ?? []

            let avgRom = average(dayWorkouts.map(\.avgRomDegrees))
            let avgStability = average(dayWorkouts.map(\.avgStabilityPercent))
            days.append(InsightsReport.Day(
                date: dateString,
                weekday: weekday,
                avgRomDegrees: avgRom.map(round1),
                avgStabilityPercent: avgStability.map(round1),
                performance: avgRom.flatMap { rom in
                    avgStability.map { performanceScore(rom: rom, stability: $0) }
                },
                totalReps: dayWorkouts.reduce(0) { $0 + $1.totalReps }
            ))

            for entry in ExercisePlan.entries where entry.weekdays.contains(index) {
                let completed = dayWorkouts
                    .filter { $0.exercise == entry.exercise }
                    .reduce(0) { $0 + $1.totalReps }
                adherence.append(InsightsReport.AdherenceEntry(
                    date: dateString,
                    weekday: weekday,
                    exercise: entry.exercise,
                    plannedReps: entry.plannedReps,
                    completedReps: completed,
                    percent: round1(min(100, Double(completed) / Double(entry.plannedReps) * 100))
                ))
            }
        }

        let scored = days.compactMap(\.performance)
        return InsightsReport(
            weekStart: formatter.string(from: dates[0]),
            days: days,
            performance: scored.isEmpty
                ? nil : round1(scored.reduce(0, +) / Double(scored.count)),
            totalReps: days.reduce(0) { $0 + $1.totalReps },
            adherence: adherence
        )
    }

    private static func average(_ values: [Double]) -> Double? {
        values.isEmpty ? nil : values.reduce(0, +) / Double(values.count)
    }

    private static func round1(_ value: Double) -> Double {
        (value * 10).rounded() / 10
    }
}
