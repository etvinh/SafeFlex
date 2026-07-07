import Foundation

/// One prescribed exercise: sets/reps targets and the weekdays
/// (0 = Monday) it is due.
struct PlanEntry: Sendable {
    let exercise: String
    let sets: Int
    let repsPerSet: Int
    let weekdays: [Int]

    var plannedReps: Int { sets * repsPerSet }
}

/// The prescribed weekly program — the single source of truth used both
/// for live-session targets and for adherence scoring in Insights.
enum ExercisePlan {
    static let entries: [PlanEntry] = [
        PlanEntry(exercise: "Shoulder Abduction", sets: 3, repsPerSet: 12,
                  weekdays: [0, 1, 2, 3, 4, 6]),
        PlanEntry(exercise: "Wrist Flexion", sets: 2, repsPerSet: 15,
                  weekdays: [0, 2, 4, 5]),
        PlanEntry(exercise: "Neck Stretch", sets: 3, repsPerSet: 1,
                  weekdays: [1, 3, 5]),
    ]

    static func entry(for exercise: String) -> PlanEntry? {
        entries.first { $0.exercise == exercise }
    }
}
