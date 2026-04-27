import SwiftUI

struct SignInView: View {
    var onBack: () -> Void
    var onSuccess: () -> Void
    var onSignUp: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0C1222").ignoresSafeArea()
            RadialGradient(colors: [Theme.authAccent.opacity(0.22), .clear],
                           center: .init(x: 0.7, y: 0), startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            RadialGradient(colors: [Theme.authAccent.opacity(0.12), .clear],
                           center: .init(x: 0.1, y: 0.72), startRadius: 0, endRadius: 250)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)

                    // Back
                    HStack {
                        Button(action: onBack) {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 12, weight: .medium))
                                Text("Back")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundStyle(.white.opacity(0.55))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 14)

                    // Header
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Theme.authAccent)
                            .frame(width: 52, height: 52)
                            .shadow(color: Theme.authAccent.opacity(0.5), radius: 12)
                            .overlay(ShieldIcon(size: 20))

                        Text("Sign In")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(.white)
                            .tracking(-0.5)

                        Text("Welcome back to your recovery journey.")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.45))
                    }

                    Spacer().frame(height: 20)

                    // Form card
                    VStack(spacing: 14) {
                        // Email
                        VStack(alignment: .leading, spacing: 5) {
                            Text("EMAIL ADDRESS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Theme.authLabel)
                                .tracking(0.7)
                            TextField("", text: $email, prompt: Text("name@example.com").foregroundStyle(.white.opacity(0.22)))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .modifier(AuthInputStyle())
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 5) {
                            Text("PASSWORD")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Theme.authLabel)
                                .tracking(0.7)

                            ZStack(alignment: .trailing) {
                                Group {
                                    if showPassword {
                                        TextField("", text: $password, prompt: Text("••••••••").foregroundStyle(.white.opacity(0.22)))
                                    } else {
                                        SecureField("", text: $password, prompt: Text("••••••••").foregroundStyle(.white.opacity(0.22)))
                                    }
                                }
                                .modifier(AuthInputStyle())

                                Button(action: { showPassword.toggle() }) {
                                    Text(showPassword ? "HIDE" : "SHOW")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white.opacity(0.35))
                                        .tracking(0.5)
                                }
                                .padding(.trailing, 14)
                            }

                            HStack {
                                Spacer()
                                Button("Forgot password?") {}
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color(hex: "#B4C5FF"))
                            }
                        }

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "#FCA5A5"))
                        }

                        // Sign In button
                        Button(action: signIn) {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Sign In →")
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isLoading ? Theme.authAccent.opacity(0.6) : Theme.authAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(isLoading)

                        // Divider
                        HStack(spacing: 10) {
                            Rectangle().fill(.white.opacity(0.09)).frame(height: 1)
                            Text("or")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.white.opacity(0.28))
                            Rectangle().fill(.white.opacity(0.09)).frame(height: 1)
                        }

                        // Apple Sign In
                        Button(action: signIn) {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 16))
                                Text("Sign in with Apple")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundStyle(Color(hex: "#1A1A1A"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(22)
                    .background(Theme.authCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.authBorder, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    // Sign up link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.white.opacity(0.38))
                        Button("Sign up", action: onSignUp)
                            .foregroundStyle(Color(hex: "#B4C5FF"))
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 13))
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
            }
        }
    }

    private func signIn() {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
            return
        }
        isLoading = true
        errorMessage = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            isLoading = false
            onSuccess()
        }
    }
}

struct AuthInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
    }
}
