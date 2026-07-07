import Foundation

/// Exercise recommendation via the Claude API.
///
/// PLACEHOLDER: not wired to the real API yet. The request below is the
/// correct wire shape (claude-opus-4-8, structured output via
/// output_config.format so the reply is guaranteed-valid JSON), but until
/// `apiKey` is set this type answers with a local keyword match instead
/// of a network call. To go live, supply a key at runtime — do NOT commit
/// one here; for production route the call through a backend/edge
/// function so the key never ships inside the app binary.
struct ClaudeExerciseRecommender: ExerciseRecommender {
    static let apiKey = "YOUR_ANTHROPIC_API_KEY"  // placeholder — leave as-is

    /// Exercises the model may choose from (matches the app's catalog).
    static let catalog = [
        "Shoulder Abduction", "Wrist Flexion", "Neck Stretch",
        "Hip Abduction", "Scapular Squeeze", "Bicep Curls", "Quad Extension",
    ]

    func recommend(
        painDescription: String,
        sessionsPerWeek: Int,
        weightKg: Double
    ) async -> (recommendations: [RecommendedExercise], summary: String) {
        guard Self.apiKey != "YOUR_ANTHROPIC_API_KEY" else {
            return Self.keywordFallback(for: painDescription)
        }
        do {
            return try await requestFromClaude(
                painDescription: painDescription,
                sessionsPerWeek: sessionsPerWeek,
                weightKg: weightKg
            )
        } catch {
            print("[Claude] Recommendation failed, using fallback: \(error)")
            return Self.keywordFallback(for: painDescription)
        }
    }

    // MARK: - Claude API (placeholder — correct shape, not yet enabled)

    private struct ClaudeReply: Codable {
        let recommendations: [RecommendedExercise]
        let summary: String
    }

    private func requestFromClaude(
        painDescription: String,
        sessionsPerWeek: Int,
        weightKg: Double
    ) async throws -> (recommendations: [RecommendedExercise], summary: String) {
        var request = URLRequest(url: URL(string: "https://api.anthropic.com/v1/messages")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Self.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let prompt = """
        You are a physical therapy assistant for the SafeFlex wearable rehab app. \
        A user describes their pain and issues; recommend 2-4 exercises from the \
        catalog that target those issues, with a one-sentence reason each, plus a \
        short encouraging summary. Catalog: \(Self.catalog.joined(separator: ", ")).

        User profile: trains \(sessionsPerWeek)x per week, weighs \(Int(weightKg)) kg.
        Pain description: \(painDescription)
        """

        // output_config.format guarantees the reply text is valid JSON
        // matching this schema.
        let body: [String: Any] = [
            "model": "claude-opus-4-8",
            "max_tokens": 16000,
            "thinking": ["type": "adaptive"],
            "messages": [["role": "user", "content": prompt]],
            "output_config": [
                "format": [
                    "type": "json_schema",
                    "schema": [
                        "type": "object",
                        "properties": [
                            "recommendations": [
                                "type": "array",
                                "items": [
                                    "type": "object",
                                    "properties": [
                                        "exercise": ["type": "string", "enum": Self.catalog],
                                        "reason": ["type": "string"],
                                    ],
                                    "required": ["exercise", "reason"],
                                    "additionalProperties": false,
                                ],
                            ],
                            "summary": ["type": "string"],
                        ],
                        "required": ["recommendations", "summary"],
                        "additionalProperties": false,
                    ],
                ],
            ],
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let content = response?["content"] as? [[String: Any]],
              let text = content.first(where: { $0["type"] as? String == "text" })?["text"] as? String,
              let reply = try? JSONDecoder().decode(ClaudeReply.self, from: Data(text.utf8))
        else {
            throw URLError(.cannotParseResponse)
        }
        return (reply.recommendations, reply.summary)
    }

    // MARK: - Local fallback (keyword matching)

    static func keywordFallback(
        for painDescription: String
    ) -> (recommendations: [RecommendedExercise], summary: String) {
        let text = painDescription.lowercased()
        var picks: [RecommendedExercise] = []

        func add(_ exercise: String, _ reason: String) {
            guard !picks.contains(where: { $0.exercise == exercise }) else { return }
            picks.append(RecommendedExercise(exercise: exercise, reason: reason))
        }

        if text.contains("shoulder") || text.contains("arm") {
            add("Shoulder Abduction", "Rebuilds shoulder range of motion with controlled lifts.")
            add("Scapular Squeeze", "Strengthens the muscles that stabilize the shoulder blade.")
        }
        if text.contains("wrist") || text.contains("hand") || text.contains("typing") {
            add("Wrist Flexion", "Gently restores wrist mobility and grip endurance.")
        }
        if text.contains("neck") || text.contains("headache") || text.contains("posture") {
            add("Neck Stretch", "Releases neck tension and improves head posture.")
            add("Scapular Squeeze", "Counteracts rounded shoulders that strain the neck.")
        }
        if text.contains("hip") || text.contains("lower back") || text.contains("back") {
            add("Hip Abduction", "Strengthens hip stabilizers that support the lower back.")
        }
        if text.contains("knee") || text.contains("leg") {
            add("Quad Extension", "Builds the quad strength that protects the knee joint.")
            add("Hip Abduction", "Stabilizes the hip to reduce load on the knee.")
        }
        if text.contains("elbow") || text.contains("bicep") {
            add("Bicep Curls", "Rebuilds elbow strength through a controlled range.")
        }
        if picks.isEmpty {
            add("Shoulder Abduction", "A gentle full-range starting point for upper-body recovery.")
            add("Neck Stretch", "Low-impact mobility work suitable for most recovery plans.")
        }

        return (
            Array(picks.prefix(4)),
            "Here's a starting plan based on what you described. "
                + "You can adjust it anytime from the Exercises tab."
        )
    }
}
