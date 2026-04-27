import SwiftUI

struct UploadProtocolView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isScanning = false
    @State private var isDone = false
    @State private var progress: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Upload Protocol")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundStyle(Theme.primary)
                            .tracking(-0.8)
                        Text("Digitize your recovery plan with medical-grade precision.")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.secondary)
                    }
                    .padding(.bottom, 18)

                    // AI Engine card
                    GlassCard {
                        HStack(alignment: .top, spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.primaryFixed)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "doc.text")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Theme.primary)
                                )

                            VStack(alignment: .leading, spacing: 5) {
                                Text("AI Processing Engine")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Theme.onSurface)
                                Text("Our clinical AI scans your PDF to identify exercises, frequency, and safety precautions — creating a structured, interactive regimen tailored to your doctor's orders.")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Theme.onSurfaceVariant)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(15)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Theme.authAccent.opacity(0.04), radius: 8, y: 4)
                    .padding(.bottom, 16)

                    // Upload zone / Success
                    if !isDone {
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Theme.primary.opacity(0.08))
                                .frame(width: 72, height: 72)
                                .overlay(
                                    Image(systemName: "doc.badge.arrow.up")
                                        .font(.system(size: 28))
                                        .foregroundStyle(Theme.primary)
                                )

                            VStack(spacing: 3) {
                                Text("Drag and drop your PDF")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Theme.primary)
                                Text("or tap to browse local files")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Theme.outline)
                            }

                            Text("Supported: PDF (Max 25MB)")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.onSurfaceVariant)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(Theme.surfaceContainer)
                                .clipShape(Capsule())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 36)
                        .background(Theme.primaryFixed.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Theme.primary.opacity(0.22), style: StrokeStyle(lineWidth: 2, dash: [6]))
                        )
                        .padding(.bottom, 16)
                    } else {
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: "#F0FDF4"))
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Circle().stroke(Color(hex: "#BBF7D0"), lineWidth: 2)
                                )
                                .overlay(
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundStyle(Color(hex: "#15803D"))
                                )

                            Text("Protocol Processed!")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color(hex: "#15803D"))
                            Text("3 exercises extracted and added to your program.")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#166534"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(hex: "#F0FDF4").opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#BBF7D0"), lineWidth: 1)
                        )
                        .padding(.bottom, 16)
                    }

                    // HIPAA badge
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "#15803D"))
                        Text("HIPAA Compliant & Encrypted Data Processing")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.onSurfaceVariant)
                    }
                    .padding(.bottom, 14)

                    // Action area
                    if isScanning {
                        VStack(spacing: 8) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Theme.surfaceContainer).frame(height: 6)
                                    Capsule().fill(Theme.primary)
                                        .frame(width: geo.size.width * progress / 100, height: 6)
                                }
                            }
                            .frame(height: 6)

                            Text("Scanning… \(Int(progress))%")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.outline)
                                .frame(maxWidth: .infinity)
                        }
                    } else if !isDone {
                        VStack(spacing: 8) {
                            Button(action: startScan) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 16))
                                    Text("Start Scan")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Theme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 13))
                                .shadow(color: Theme.primary.opacity(0.4), radius: 8, y: 4)
                            }
                            Text("Scan time: ~15 seconds")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.outline)
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        Button { dismiss() } label: {
                            Text("View My Program")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(hex: "#15803D"))
                                .clipShape(RoundedRectangle(cornerRadius: 13))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
            .background(Theme.surface)
            .navigationTitle("TherapyPulse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.primary)
                }
            }
        }
    }

    private func startScan() {
        isScanning = true
        progress = 0
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            progress += 7
            if progress >= 100 {
                timer.invalidate()
                isScanning = false
                isDone = true
            }
        }
    }
}
