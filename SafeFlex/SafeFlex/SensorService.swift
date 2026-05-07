import Foundation

struct SensorReading: Decodable, Sendable {
    let timestamp: Int
    let flex: Double
    let stability: Double
}

@Observable
class SensorService {
    var flex: Double = 0
    var stability: Double = 0
    var isConnected = false

    var flexPercent: Int {
        min(100, max(0, Int(flex / 1000.0 * 100)))
    }

    var stabilityPercent: Int {
        min(100, max(0, Int(stability / 5.0 * 100)))
    }

    private var webSocketTask: URLSessionWebSocketTask?
    private var connectionTask: Task<Void, Never>?
    private var serverAddress = ""
    private let decoder = JSONDecoder()

    func connect(to address: String) {
        disconnect()
        serverAddress = address
        let urlString = "ws://\(address)"
        guard let url = URL(string: urlString) else {
            print("[Sensor] Invalid URL: \(urlString)")
            return
        }
        print("[Sensor] Connecting to \(urlString)...")
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true

        connectionTask = Task { await receiveMessages() }
    }

    func disconnect() {
        connectionTask?.cancel()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
    }

    private func receiveMessages() async {
        guard let task = webSocketTask else { return }

        do {
            while !Task.isCancelled {
                let message = try await task.receive()
                let data: Data? = switch message {
                case .string(let text): text.data(using: .utf8)
                case .data(let d): d
                @unknown default: nil
                }
                guard let data else { continue }
                guard let reading = try? decoder.decode(SensorReading.self, from: data) else {
                    print("[Sensor] Failed to decode: \(String(data: data, encoding: .utf8) ?? "?")")
                    continue
                }
                flex = reading.flex
                stability = reading.stability
            }
        } catch {
            print("[Sensor] Connection error: \(error)")
            guard !Task.isCancelled else { return }
            isConnected = false
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            print("[Sensor] Reconnecting...")
            connect(to: serverAddress)
        }
    }
}
