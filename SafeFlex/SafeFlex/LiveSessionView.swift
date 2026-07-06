import SwiftUI

struct LiveSessionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var sensor = SensorService()
    @State private var seconds = 0
    @State private var reps = 0
    @State private var currentSet = 1
    @State private var isPaused = false
    @State private var flash = false
    @State private var showServerConfig = false
    @State private var flexWasAboveHalf = false
    @State private var sessionStart = Date()
    @State private var repPeakFlex: Double = 0
    @State private var repStabilitySum: Double = 0
    @State private var repStabilitySamples = 0
    @State private var romPerRep: [Double] = []
    @State private var stabilityPerRep: [Double] = []
    @AppStorage("sensorAddress") private var serverAddress = "10.0.0.138:8080"

    private let totalReps = 12
    private let totalSets = 3

    private var progress: Double {
        Double(min(reps, totalReps)) / Double(totalReps)
    }
    private var overallProgress: Double {
        Double((currentSet - 1) * totalReps + min(reps, totalReps)) / Double(totalSets * totalReps)
    }
    private var timeFormatted: String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        VStack(spacing: 0) {
            // App bar
            HStack {
                HStack(spacing: 9) {
                    Circle()
                        .fill(Theme.primary)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text("SJ")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundStyle(.white)
                        )
                    Text("SafeFlex")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(Theme.primary)
                        .tracking(-0.3)
                }
                Spacer()
                Button { showServerConfig = true } label: {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(sensor.isConnected ? Theme.success : Color(hex: "#DC2626"))
                            .frame(width: 6, height: 6)
                            .shadow(color: sensor.isConnected ? Theme.success.opacity(0.7) : .clear, radius: 3)
                        Text(sensor.isConnected ? "CONNECTED" : "DISCONNECTED")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(sensor.isConnected ? Color(hex: "#15803D") : Color(hex: "#DC2626"))
                            .tracking(1)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 24)
                    .background(sensor.isConnected ? Color(hex: "#F0FDF4") : Color(hex: "#FEF2F2"))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(
                            sensor.isConnected ? Color(hex: "#BBF7D0") : Color(hex: "#FECACA"),
                            lineWidth: 1
                        )
                    )
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 64)
            .background(.white)

            // Exercise info
            VStack(spacing: 3) {
                Text(appState.activeExercise)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.onSurface)
                Text("Maintain steady tension. Lift arm smoothly to shoulder height.")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)

                HStack(spacing: 6) {
                    PillBadge(text: "Set \(currentSet)/\(totalSets)", bg: Color(hex: "#EFF6FF"), fg: Theme.primary)
                    PillBadge(text: "Rep \(min(reps, totalReps))/\(totalReps)", bg: Color(hex: "#F0FDF4"), fg: Color(hex: "#15803D"))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // Central region
            HStack(spacing: 8) {
                MetricBar(
                    value: sensor.isConnected ? sensor.flexPercent : 0,
                    label: "Flex",
                    displayValue: sensor.isConnected ? String(Int(sensor.flex)) : "—"
                )

                VStack(spacing: 8) {
                    // Timer
                    HStack(spacing: 7) {
                        Image(systemName: "timer")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.primary)
                        Text(timeFormatted)
                            .font(.system(size: 16, weight: .heavy, design: .monospaced))
                            .foregroundStyle(Theme.primary)
                            .tracking(1)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 36)
                    .background(.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Theme.outlineVariant.opacity(0.5), lineWidth: 1))
                    .shadow(color: .black.opacity(0.06), radius: 2, y: 1)

                    // Rep ring
                    repRing
                }

                MetricBar(
                    value: sensor.isConnected ? sensor.stabilityPercent : 0,
                    label: "Stability",
                    displayValue: sensor.isConnected
                        ? String(format: "%.1f", sensor.stability)
                        : "—"
                )
            }
            .padding(.horizontal, 12)
            .frame(maxHeight: .infinity)

            // Actions
            VStack(spacing: 9) {
                Button {
                    endSession()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 14))
                        Text("STOP — I'M IN PAIN")
                            .font(.system(size: 14, weight: .heavy))
                            .tracking(1.2)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color(hex: "#DC2626"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color(hex: "#DC2626").opacity(0.38), radius: 10, y: 4)
                }

                Button { isPaused.toggle() } label: {
                    HStack(spacing: 7) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 11))
                        Text(isPaused ? "Resume Session" : "Pause Session")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(isPaused ? Theme.primary : Theme.secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.surfaceHighest.opacity(0.8), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.surfaceHighest.opacity(0.25))
                    Rectangle().fill(Theme.primary)
                        .frame(width: geo.size.width * overallProgress)
                        .shadow(color: Theme.primary.opacity(0.4), radius: 4)
                        .animation(.easeInOut(duration: 0.45), value: overallProgress)
                }
            }
            .frame(height: 5)
        }
        .background(Theme.surface)
        .onAppear {
            sessionStart = Date()
            sensor.connect(to: serverAddress)
            startTimer()
        }
        .onDisappear {
            sensor.disconnect()
        }
        .onChange(of: sensor.flex) { _, newFlex in
            guard !isPaused, sensor.isConnected else { return }
            repPeakFlex = max(repPeakFlex, newFlex)
            repStabilitySum += sensor.stability
            repStabilitySamples += 1
            if sensor.flexPercent >= 50 {
                flexWasAboveHalf = true
            } else if flexWasAboveHalf {
                flexWasAboveHalf = false
                countRep()
            }
        }
        .alert("Sensor Address", isPresented: $showServerConfig) {
            TextField("IP:Port", text: $serverAddress)
                .keyboardType(.URL)
                .autocorrectionDisabled()
            Button("Connect") {
                sensor.connect(to: serverAddress)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enter your Mac's IP and port (e.g. 192.168.1.42:8080).\nFind IP in System Settings → WiFi → Details.")
        }
    }

    private var repRing: some View {
        ZStack {
            Circle()
                .stroke(Theme.surfaceHighest.opacity(0.5), lineWidth: 15)
                .frame(width: 170, height: 170)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Theme.primary, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .frame(width: 170, height: 170)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.45), value: progress)

            VStack(spacing: 5) {
                Text("REPETITION")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Theme.secondary)
                    .tracking(2.5)
                Text("\(min(reps, totalReps))")
                    .font(.system(size: 60, weight: .light))
                    .foregroundStyle(Theme.primary)
                    .tracking(-3)
                    .scaleEffect(flash ? 1.1 : 1.0)
                    .animation(.easeOut(duration: 0.15), value: flash)

                HStack(spacing: 3) {
                    ForEach(0..<totalReps, id: \.self) { i in
                        Circle()
                            .fill(i < reps ? Theme.primary : Theme.outlineVariant)
                            .frame(width: i < reps ? 6 : 4, height: i < reps ? 6 : 4)
                            .animation(.easeInOut(duration: 0.25), value: reps)
                    }
                }
            }
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard !isPaused else { return }
            seconds += 1
        }
    }

    private func countRep() {
        reps += 1
        flash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { flash = false }

        // Record this rep: peak flex mapped to degrees (0-1000 -> 0-180°),
        // stability averaged over the rep and mapped to percent (0-5 -> 0-100).
        romPerRep.append(repPeakFlex / 1000 * 180)
        let avgStability = repStabilitySamples > 0
            ? repStabilitySum / Double(repStabilitySamples)
            : 0
        stabilityPerRep.append(min(100, max(0, avgStability / 5 * 100)))
        repPeakFlex = 0
        repStabilitySum = 0
        repStabilitySamples = 0

        if reps >= totalReps {
            if currentSet >= totalSets {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    endSession()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    currentSet += 1
                    reps = 0
                    flexWasAboveHalf = false
                }
            }
        }
    }

    private func endSession() {
        let workout = Workout(
            id: UUID(),
            exercise: appState.activeExercise,
            startedAt: sessionStart,
            endedAt: Date(),
            durationSeconds: seconds,
            totalReps: romPerRep.count,
            setsCompleted: reps >= totalReps ? currentSet : currentSet - 1,
            avgRomDegrees: romPerRep.isEmpty
                ? 0 : romPerRep.reduce(0, +) / Double(romPerRep.count),
            avgStabilityPercent: stabilityPerRep.isEmpty
                ? 0 : stabilityPerRep.reduce(0, +) / Double(stabilityPerRep.count),
            romPerRep: romPerRep,
            stabilityPerRep: stabilityPerRep
        )
        appState.lastWorkout = workout
        Task { await WorkoutUploader.upload(workout, sensorAddress: serverAddress) }

        sensor.disconnect()
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appState.showResults = true
        }
    }
}

struct PillBadge: View {
    var text: String
    var bg: Color
    var fg: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(fg)
            .padding(.horizontal, 9)
            .frame(height: 20)
            .background(bg)
            .clipShape(Capsule())
    }
}

struct MetricBar: View {
    var value: Int
    var label: String
    var displayValue: String? = nil

    var body: some View {
        VStack(spacing: 7) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.surfaceHighest.opacity(0.38))
                    .frame(width: 40, height: 170)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.surfaceHighest.opacity(0.5), lineWidth: 1)
                    )

                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(colors: [Theme.success, Theme.success.opacity(0.35)],
                                       startPoint: .bottom, endPoint: .top)
                    )
                    .frame(width: 40, height: 170 * CGFloat(value) / 100)
                    .shadow(color: Theme.success.opacity(0.28), radius: 4, y: -2)
                    .animation(.easeInOut(duration: 0.3), value: value)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(spacing: 0) {
                Text(label.uppercased())
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Theme.secondary)
                    .tracking(0.6)
                Text(displayValue ?? "\(value)%")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(Theme.onSurface)
            }
        }
    }
}
