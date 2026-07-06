import Foundation

struct InsightsReport: Codable, Sendable {
    struct Day: Codable, Sendable {
        let date: String
        let weekday: String
        let avgRomDegrees: Double?
        let avgStabilityPercent: Double?
        let performance: Double?
        let totalReps: Int
    }

    struct AdherenceEntry: Codable, Sendable {
        let date: String
        let weekday: String
        let exercise: String
        let plannedReps: Int
        let completedReps: Int
        let percent: Double
    }

    let weekStart: String
    let days: [Day]
    let performance: Double?
    let totalReps: Int
    let adherence: [AdherenceEntry]
}

enum InsightsService {
    /// Fetches this week's insights from the API server (same host as the
    /// sensor bridge, port 8081). Returns nil when the server is unreachable.
    static func fetch(sensorAddress: String) async -> InsightsReport? {
        let host = sensorAddress.split(separator: ":").first.map(String.init) ?? sensorAddress
        guard let url = URL(string: "http://\(host):8081/insights") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(InsightsReport.self, from: data)
        } catch {
            print("[Insights] Fetch failed: \(error)")
            return nil
        }
    }
}
