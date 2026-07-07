import Foundation

enum UsageType: String, Codable, Sendable {
    case prescribed
    case personal
}

struct RecommendedExercise: Codable, Sendable, Hashable {
    let exercise: String
    let reason: String
}

/// Result of first-time onboarding, stored one row per user.
struct UserProfile: Codable, Sendable {
    let usageType: UsageType
    var sessionsPerWeek: Int?
    var weightKg: Double?
    var painDescription: String?
    var recommendations: [RecommendedExercise]?
}
