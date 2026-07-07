import Foundation

/// Row shape of public.profiles (user_id filled by the database).
struct ProfileDTO: Codable {
    let usageType: String
    let sessionsPerWeek: Int?
    let weightKg: Double?
    let painDescription: String?
    let recommendations: [RecommendedExercise]?

    enum CodingKeys: String, CodingKey {
        case usageType = "usage_type"
        case sessionsPerWeek = "sessions_per_week"
        case weightKg = "weight_kg"
        case painDescription = "pain_description"
        case recommendations
    }
}
