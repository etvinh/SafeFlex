import Foundation

/// Row shape of public.weekly_logs (user_id filled by the database).
struct WeeklyLogDTO: Codable {
    let weekStart: String
    let days: [InsightsReport.Day]
    let performance: Double?
    let totalReps: Int

    enum CodingKeys: String, CodingKey {
        case days, performance
        case weekStart = "week_start"
        case totalReps = "total_reps"
    }
}

/// Row shape of public.progress_log (user_id filled by the database).
struct ProgressLogDTO: Codable {
    let date: String
    let exercise: String
    let plannedReps: Int
    let completedReps: Int
    let percent: Double

    enum CodingKeys: String, CodingKey {
        case date, exercise, percent
        case plannedReps = "planned_reps"
        case completedReps = "completed_reps"
    }
}
