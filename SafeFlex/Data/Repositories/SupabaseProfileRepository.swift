import Foundation
import Supabase

struct SupabaseProfileRepository: ProfileRepository {
    private var client: SupabaseClient { .shared }

    func currentProfile() async throws -> UserProfile? {
        let dtos: [ProfileDTO] = try await client.from("profiles")
            .select()
            .execute()
            .value
        guard let dto = dtos.first, let usage = UsageType(rawValue: dto.usageType) else {
            return nil
        }
        return UserProfile(
            usageType: usage,
            sessionsPerWeek: dto.sessionsPerWeek,
            weightKg: dto.weightKg,
            painDescription: dto.painDescription,
            recommendations: dto.recommendations
        )
    }

    func save(_ profile: UserProfile) async throws {
        try await client.from("profiles")
            .upsert(
                ProfileDTO(
                    usageType: profile.usageType.rawValue,
                    sessionsPerWeek: profile.sessionsPerWeek,
                    weightKg: profile.weightKg,
                    painDescription: profile.painDescription,
                    recommendations: profile.recommendations
                ),
                onConflict: "user_id"
            )
            .execute()
    }
}
