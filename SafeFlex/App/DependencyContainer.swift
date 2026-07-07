import Foundation
import SwiftUI

/// App-level wiring: features receive repositories through this container
/// (injected via the SwiftUI environment) and never construct Supabase
/// types themselves.
@Observable
final class DependencyContainer {
    let auth: AuthRepository
    let workouts: WorkoutRepository

    init(
        auth: AuthRepository = SupabaseAuthRepository(),
        workouts: WorkoutRepository = SupabaseWorkoutRepository()
    ) {
        self.auth = auth
        self.workouts = workouts
    }
}
