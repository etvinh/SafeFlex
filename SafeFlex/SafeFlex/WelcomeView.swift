import SwiftUI

struct WelcomeView: View {
    var onGetStarted: () -> Void
    var onSignIn: () -> Void

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "#0D1526"), Theme.authDark],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Ambient glows
            Circle()
                .fill(Theme.authAccent.opacity(0.07))
                .frame(width: 280, height: 280)
                .blur(radius: 40)
                .offset(x: 30, y: -200)

            Circle()
                .fill(Color(hex: "#1E3A8A").opacity(0.16))
                .frame(width: 240, height: 240)
                .blur(radius: 48)
                .offset(x: -60, y: 100)

            VStack(spacing: 0) {
                Spacer().frame(height: 80)

                // Brand
                VStack(spacing: 12) {
                    HStack(spacing: 11) {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Theme.authAccent)
                            .frame(width: 48, height: 48)
                            .shadow(color: Theme.authAccent.opacity(0.55), radius: 14)
                            .overlay(ShieldIcon(size: 20))

                        Text("SafeFlex")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundStyle(.white)
                            .tracking(-0.9)
                    }

                    Text("Physical therapy that knows\nwhen you're cheating.")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "#CBD5E1"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                Spacer().frame(height: 24)

                // Feature card
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.authAccent.opacity(0.18))
                        .frame(width: 68, height: 68)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.authAccent.opacity(0.3), lineWidth: 1)
                        )
                        .overlay(
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 28))
                                .foregroundStyle(Color(hex: "#DBE1FF"))
                        )

                    VStack(spacing: 4) {
                        Text("Precision Recovery")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundStyle(.white)
                            .tracking(-0.3)

                        Text("Clinical-grade motion analysis\nin the palm of your hand.")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(hex: "#94A3B8"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    // Mini bar chart
                    HStack(spacing: 5) {
                        ForEach(Array([38, 52, 44, 78, 55, 88, 68, 92, 74, 82].enumerated()), id: \.offset) { i, h in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Theme.authAccent.opacity(0.22 + Double(i) * 0.07))
                                .frame(width: 7, height: CGFloat(h) * 0.32)
                        }
                    }
                    .frame(height: 32)
                }
                .padding(22)
                .background(Color.white.opacity(0.045))
                .background(.ultraThinMaterial.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                Spacer()

                // CTAs
                VStack(spacing: 10) {
                    Button(action: onGetStarted) {
                        Text("Get Started")
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(.white)
                            .tracking(-0.3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Theme.authAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Theme.authAccent.opacity(0.42), radius: 10, y: 4)
                    }

                    Button(action: onSignIn) {
                        Text("Sign In")
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    }

                    Text("Trusted by 500+ physical therapy clinics nationwide.")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color(hex: "#475569"))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}
