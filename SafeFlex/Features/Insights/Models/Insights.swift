import Foundation

struct InsightsReport: Codable, Sendable {
    struct Day: Codable, Sendable {
        let date: String
        let weekday: String
        let avgRomDegrees: Double?
        let avgStabilityPercent: Double?
        let performance: Double?
        let totalReps: Int

        enum CodingKeys: String, CodingKey {
            case date, weekday, performance
            case avgRomDegrees = "avg_rom_degrees"
            case avgStabilityPercent = "avg_stability_percent"
            case totalReps = "total_reps"
        }
    }

    struct AdherenceEntry: Codable, Sendable {
        let date: String
        let weekday: String
        let exercise: String
        let plannedReps: Int
        let completedReps: Int
        let percent: Double

        enum CodingKeys: String, CodingKey {
            case date, weekday, exercise, percent
            case plannedReps = "planned_reps"
            case completedReps = "completed_reps"
        }
    }

    let weekStart: String
    let days: [Day]
    let performance: Double?
    let totalReps: Int
    let adherence: [AdherenceEntry]
}
