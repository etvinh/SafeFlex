import Foundation

/// Row shape of public.workouts. `user_id` is intentionally absent:
/// the database fills it from auth.uid() so a client can never write
/// somebody else's data.
struct WorkoutDTO: Codable {
    let id: UUID
    let exercise: String
    let startedAt: Date
    let endedAt: Date
    let durationSeconds: Int
    let totalReps: Int
    let setsCompleted: Int
    let avgRomDegrees: Double
    let avgStabilityPercent: Double
    let romPerRep: [Double]
    let stabilityPerRep: [Double]

    enum CodingKeys: String, CodingKey {
        case id, exercise
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case durationSeconds = "duration_seconds"
        case totalReps = "total_reps"
        case setsCompleted = "sets_completed"
        case avgRomDegrees = "avg_rom_degrees"
        case avgStabilityPercent = "avg_stability_percent"
        case romPerRep = "rom_per_rep"
        case stabilityPerRep = "stability_per_rep"
    }
}
