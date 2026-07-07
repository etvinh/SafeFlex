import Foundation

/// Turns a user's pain/issue description into exercises from the app's
/// catalog, each with a short reason.
protocol ExerciseRecommender: Sendable {
    func recommend(
        painDescription: String,
        sessionsPerWeek: Int,
        weightKg: Double
    ) async -> (recommendations: [RecommendedExercise], summary: String)
}
