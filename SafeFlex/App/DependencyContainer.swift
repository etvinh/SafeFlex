import Foundation
import SwiftUI

/// App-level wiring: features receive repositories through this container
/// (injected via the SwiftUI environment) and never construct Supabase
/// types themselves.
@Observable
final class DependencyContainer {
    let auth: AuthRepository
    let workouts: WorkoutRepository
    let profiles: ProfileRepository
    let recommender: ExerciseRecommender

    init(
        auth: AuthRepository = SupabaseAuthRepository(),
        workouts: WorkoutRepository = SupabaseWorkoutRepository(),
        profiles: ProfileRepository = SupabaseProfileRepository(),
        recommender: ExerciseRecommender = ClaudeExerciseRecommender()
    ) {
        self.auth = auth
        self.workouts = workouts
        self.profiles = profiles
        self.recommender = recommender
    }
}
