import Foundation

struct Workout: Codable, Sendable {
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
}
