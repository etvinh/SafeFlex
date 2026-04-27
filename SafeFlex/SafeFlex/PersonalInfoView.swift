import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "Alex Johnson"
    @State private var dob = "May 14, 1988"
    @State private var email = "alex@safeflex.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var emergencyName = "Sarah Johnson"
    @State private var emergencyPhone = "+1 (555) 987-6543"
    @State private var saved = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Avatar
                    VStack(spacing: 10) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#DBEAFE"), Color(hex: "#EFF6FF")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 96, height: 96)
                                .overlay(Circle().stroke(.white, lineWidth: 3))
                                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                                .overlay(
                                    Text("AJ")
                                        .font(.system(size: 34, weight: .heavy))
                                        .foregroundStyle(Theme.primary)
                                )

                            Circle()
                                .fill(Theme.primaryContainer)
                                .frame(width: 30, height: 30)
                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                .shadow(color: Theme.authAccent.opacity(0.4), radius: 4, y: 2)
                                .overlay(
                                    Image(systemName: "pencil")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }

                        Text("Alex Johnson")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Theme.onSurface)
                        Text("Patient ID: SF-2934-PT")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.secondary)
                    }
                    .padding(.vertical, 20)

                    // Identity section
                    FormSection(icon: "person.text.rectangle", title: "IDENTITY") {
                        FormField(label: "Full Name", text: $name, placeholder: "Alex Johnson")
                        FormField(label: "Date of Birth", text: $dob, placeholder: "May 14, 1988",
                                  trailingIcon: "calendar")
                    }

                    // Contact Details section
                    FormSection(icon: "envelope.fill", title: "CONTACT DETAILS") {
                        FormField(label: "Email Address", text: $email, placeholder: "alex@safeflex.com",
                                  keyboardType: .emailAddress)
                        FormField(label: "Phone Number", text: $phone, placeholder: "+1 (555) 123-4567",
                                  keyboardType: .phonePad)
                    }

                    // Emergency Contact section
                    FormSection(icon: "exclamationmark.triangle.fill", title: "EMERGENCY CONTACT",
                                iconColor: Theme.error) {
                        FormField(label: "Contact Name", text: $emergencyName, placeholder: "Sarah Johnson")
                        FormField(label: "Contact Phone", text: $emergencyPhone, placeholder: "+1 (555) 987-6543",
                                  keyboardType: .phonePad)
                    }

                    // Save button
                    Button {
                        saved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { saved = false }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: saved ? "checkmark" : "square.and.arrow.down")
                                .font(.system(size: 16))
                            Text(saved ? "Saved!" : "Save Changes")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(saved ? Color(hex: "#15803D") : Theme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                        .shadow(color: Theme.primary.opacity(0.4), radius: 8, y: 4)
                        .animation(.easeInOut(duration: 0.3), value: saved)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                    Text("Your data is encrypted and stored securely.")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.outline)
                        .padding(.top, 12)
                        .padding(.bottom, 32)
                }
            }
            .background(Theme.surface)
            .navigationTitle("Edit Personal Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.primary)
                }
            }
        }
    }
}

struct FormSection<Content: View>: View {
    var icon: String
    var title: String
    var iconColor: Color = Theme.primary
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(iconColor)
                    .tracking(0.8)
                Spacer()
            }
            .padding(.bottom, 4)

            content()
        }
        .padding(16)
        .background(.white.opacity(0.72))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.45), lineWidth: 1)
        )
        .shadow(color: Theme.primary.opacity(0.04), radius: 8, y: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }
}

struct FormField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var trailingIcon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.onSurfaceVariant)
                .padding(.leading, 2)

            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.onSurface)
                    .padding(.horizontal, 13)
                    .frame(height: 46)
                    .background(.white.opacity(0.65))
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Theme.outlineVariant, lineWidth: 1)
                    )

                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.outline)
                        .padding(.trailing, 12)
                }
            }
        }
    }
}
