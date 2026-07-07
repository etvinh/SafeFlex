import Foundation
import Supabase

struct SupabaseWorkoutRepository: WorkoutRepository {
    private var client: SupabaseClient { .shared }

    func save(_ workout: Workout) async throws {
        try await client.from("workouts")
            .insert(WorkoutMapper.dto(from: workout))
            .execute()
    }

    func workouts(from: Date, to: Date) async throws -> [Workout] {
        let dtos: [WorkoutDTO] = try await client.from("workouts")
            .select()
            .gte("ended_at", value: from.ISO8601Format())
            .lte("ended_at", value: to.ISO8601Format())
            .execute()
            .value
        return dtos.map(WorkoutMapper.domain)
    }

    func persistLogs(for report: InsightsReport) async throws {
        try await client.from("weekly_logs")
            .upsert(
                WeeklyLogDTO(
                    weekStart: report.weekStart,
                    days: report.days,
                    performance: report.performance,
                    totalReps: report.totalReps
                ),
                onConflict: "user_id,week_start"
            )
            .execute()

        let entries = report.adherence.map {
            ProgressLogDTO(
                date: $0.date,
                exercise: $0.exercise,
                plannedReps: $0.plannedReps,
                completedReps: $0.completedReps,
                percent: $0.percent
            )
        }
        try await client.from("progress_log")
            .upsert(entries, onConflict: "user_id,date,exercise")
            .execute()
    }
}
