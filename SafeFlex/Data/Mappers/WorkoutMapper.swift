import Foundation

enum WorkoutMapper {
    static func dto(from workout: Workout) -> WorkoutDTO {
        WorkoutDTO(
            id: workout.id,
            exercise: workout.exercise,
            startedAt: workout.startedAt,
            endedAt: workout.endedAt,
            durationSeconds: workout.durationSeconds,
            totalReps: workout.totalReps,
            setsCompleted: workout.setsCompleted,
            avgRomDegrees: workout.avgRomDegrees,
            avgStabilityPercent: workout.avgStabilityPercent,
            romPerRep: workout.romPerRep,
            stabilityPerRep: workout.stabilityPerRep
        )
    }

    static func domain(from dto: WorkoutDTO) -> Workout {
        Workout(
            id: dto.id,
            exercise: dto.exercise,
            startedAt: dto.startedAt,
            endedAt: dto.endedAt,
            durationSeconds: dto.durationSeconds,
            totalReps: dto.totalReps,
            setsCompleted: dto.setsCompleted,
            avgRomDegrees: dto.avgRomDegrees,
            avgStabilityPercent: dto.avgStabilityPercent,
            romPerRep: dto.romPerRep,
            stabilityPerRep: dto.stabilityPerRep
        )
    }
}
