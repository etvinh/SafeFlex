import Foundation

struct Workout: Codable, Sendable {
    let id: UUID
    let exercise: String
    let startedAt: Date
    let endedAt: Date
    let durationSeconds: Int
    let totalReps: Int
    let setsCompleted: Int
    let avgRomDegrees: Double
    let avgStabilityPercent: Double
    let romPerRep: [Double]
    let stabilityPerRep: [Double]
}

enum WorkoutUploader {
    /// Posts the workout to the API server, assumed to run on the same
    /// host as the sensor bridge (Scripts/workout_api.py, port 8081).
    static func upload(_ workout: Workout, sensorAddress: String) async {
        let host = sensorAddress.split(separator: ":").first.map(String.init) ?? sensorAddress
        guard let url = URL(string: "http://\(host):8081/workouts") else {
            print("[Workout] Invalid API host: \(host)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        do {
            request.httpBody = try encoder.encode(workout)
            let (_, response) = try await URLSession.shared.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            print("[Workout] Saved to server, status \(status)")
        } catch {
            print("[Workout] Upload failed: \(error)")
        }
    }
}
