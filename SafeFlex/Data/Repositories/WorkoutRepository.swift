import Foundation

/// Abstraction for workout storage. Everything is implicitly scoped to
/// the signed-in user — enforced by the database, not the caller.
protocol WorkoutRepository: Sendable {
    func save(_ workout: Workout) async throws
    /// Workouts whose end date falls within the given day range (inclusive).
    func workouts(from: Date, to: Date) async throws -> [Workout]
    /// Persists the derived weekly ROM/stability log and the per-exercise
    /// progress log for the signed-in user.
    func persistLogs(for report: InsightsReport) async throws
}
