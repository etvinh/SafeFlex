import Foundation
import Observation

@MainActor
@Observable
final class OnboardingViewModel {
    enum Step {
        case usage
        case prescribedUpload
        case personalDetails
        case describeIssues
        case plan
    }

    var step: Step = .usage
    var usageType: UsageType?
    var sessionsPerWeek = 3
    var weightKg = 70.0
    var painDescription = ""
    var isLoading = false
    var recommendations: [RecommendedExercise] = []
    var planSummary = ""

    private let profiles: ProfileRepository
    private let recommender: ExerciseRecommender

    init(profiles: ProfileRepository, recommender: ExerciseRecommender) {
        self.profiles = profiles
        self.recommender = recommender
    }

    func choose(_ type: UsageType) {
        usageType = type
        step = type == .prescribed ? .prescribedUpload : .personalDetails
    }

    func continueToIssues() {
        step = .describeIssues
    }

    /// Personal path: get exercise recommendations for the described issues.
    func generatePlan() async {
        isLoading = true
        defer { isLoading = false }
        let result = await recommender.recommend(
            painDescription: painDescription,
            sessionsPerWeek: sessionsPerWeek,
            weightKg: weightKg
        )
        recommendations = result.recommendations
        planSummary = result.summary
        step = .plan
    }

    /// Persists the profile; returns true when done so the caller can
    /// dismiss onboarding (saving is best-effort — a network hiccup
    /// shouldn't trap the user in onboarding).
    func finish() async -> Bool {
        let profile = UserProfile(
            usageType: usageType ?? .personal,
            sessionsPerWeek: usageType == .personal ? sessionsPerWeek : nil,
            weightKg: usageType == .personal ? weightKg : nil,
            painDescription: painDescription.isEmpty ? nil : painDescription,
            recommendations: recommendations.isEmpty ? nil : recommendations
        )
        do {
            try await profiles.save(profile)
        } catch {
            print("[Onboarding] Profile save failed: \(error)")
        }
        return true
    }
}
