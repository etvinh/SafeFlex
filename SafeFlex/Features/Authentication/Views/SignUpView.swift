import SwiftUI

struct SignUpView: View {
    @State var viewModel: AuthViewModel
    var onBack: () -> Void
    var onSuccess: (User) -> Void
    var onSignIn: () -> Void

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    private var isLoading: Bool { viewModel.isLoading }

    var body: some View {
        ZStack {
            Color(hex: "#0C1222").ignoresSafeArea()
            RadialGradient(colors: [Theme.authAccent.opacity(0.24), .clear],
                           center: .init(x: 0.28, y: -0.05), startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            RadialGradient(colors: [Color(hex: "#1E3A8A").opacity(0.24), .clear],
                           center: .init(x: 0.82, y: 0.78), startRadius: 0, endRadius: 250)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)

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

                    Spacer().frame(height: 12)

                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Theme.authAccent)
                            .frame(width: 48, height: 48)
                            .shadow(color: Theme.authAccent.opacity(0.5), radius: 11)
                            .overlay(ShieldIcon(size: 19))

                        Text("Create Account")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundStyle(.white)
                            .tracking(-0.5)

                        Text("Start your recovery journey today.")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.4))
                    }

                    Spacer().frame(height: 18)

                    VStack(spacing: 13) {
                        AuthField(label: "FULL NAME", text: $name, placeholder: "Alex Johnson")
                        AuthField(label: "EMAIL ADDRESS", text: $email, placeholder: "name@example.com", keyboardType: .emailAddress)
                        AuthField(label: "PASSWORD", text: $password, placeholder: "8+ characters", isSecure: true)

                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "#FCA5A5"))
                        }

                        Button(action: createAccount) {
                            Group {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Create Account →")
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
                        .padding(.top, 4)

                        Text("By creating an account you agree to our Terms of Service and Privacy Policy.")
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.22))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding(22)
                    .background(Theme.authCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.authBorder, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.white.opacity(0.38))
                        Button("Sign in", action: onSignIn)
                            .foregroundStyle(Color(hex: "#B4C5FF"))
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 13))
                    .padding(.top, 14)
                    .padding(.bottom, 28)
                }
            }
        }
    }

    private func createAccount() {
        Task {
            if let user = await viewModel.signUp(name: name, email: email, password: password) {
                onSuccess(user)
            }
        }
    }
}

struct AuthField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.authLabel)
                .tracking(0.7)

            Group {
                if isSecure {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.22)))
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.22)))
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                }
            }
            .modifier(AuthInputStyle())
        }
    }
}
