import SwiftUI

/// First-time onboarding: how the user will use SafeFlex, then either a
/// protocol upload (prescribed) or a short intake + AI plan (personal).
struct OnboardingView: View {
    @State var viewModel: OnboardingViewModel
    var onComplete: () -> Void

    @State private var showUpload = false

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                Group {
                    switch viewModel.step {
                    case .usage:
                        UsageStepView(viewModel: viewModel)
                    case .prescribedUpload:
                        PrescribedStepView(
                            viewModel: viewModel,
                            showUpload: $showUpload,
                            onComplete: finish
                        )
                    case .personalDetails:
                        PersonalDetailsStepView(viewModel: viewModel)
                    case .describeIssues:
                        DescribeIssuesStepView(viewModel: viewModel)
                    case .plan:
                        PlanStepView(viewModel: viewModel, onComplete: finish)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
        }
        .background(Theme.surface)
        .animation(.easeInOut(duration: 0.25), value: viewModel.step)
        .sheet(isPresented: $showUpload) {
            UploadProtocolView()
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                SafeFlexLogo()
                Spacer()
            }
            ProgressView(value: progress)
                .tint(Theme.primary)
        }
        .padding(.horizontal, 22)
        .padding(.top, 12)
    }

    private var progress: Double {
        switch viewModel.step {
        case .usage: 0.25
        case .prescribedUpload, .personalDetails: 0.5
        case .describeIssues: 0.75
        case .plan: 1.0
        }
    }

    private func finish() {
        Task {
            if await viewModel.finish() {
                onComplete()
            }
        }
    }
}

// MARK: - Step 1: How will you use SafeFlex?

private struct UsageStepView: View {
    var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            StepTitle(
                title: "Welcome to SafeFlex",
                subtitle: "How will you be using the app? This helps us set up the right plan for you."
            )

            ChoiceCard(
                icon: "doc.text.fill",
                title: "Prescribed by my PT",
                subtitle: "I have a regimen from a physical therapist or doctor."
            ) { viewModel.choose(.prescribed) }

            ChoiceCard(
                icon: "heart.fill",
                title: "Personal recovery",
                subtitle: "I'm managing pain or mobility on my own."
            ) { viewModel.choose(.personal) }
        }
    }
}

// MARK: - Step 2a: Prescribed — upload the protocol

private struct PrescribedStepView: View {
    var viewModel: OnboardingViewModel
    @Binding var showUpload: Bool
    var onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            StepTitle(
                title: "Your prescribed regimen",
                subtitle: "Upload the protocol from your provider and SafeFlex will track your sessions against it."
            )

            ChoiceCard(
                icon: "square.and.arrow.up.fill",
                title: "Upload protocol",
                subtitle: "PDF or photo from your PT."
            ) { showUpload = true }

            PrimaryOnboardingButton(title: "Done", action: onComplete)
                .padding(.top, 12)

            Button("Skip for now", action: onComplete)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
        }
    }
}

// MARK: - Step 2b: Personal — frequency and weight

private struct PersonalDetailsStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let frequencies = [2, 3, 4, 5, 6]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            StepTitle(
                title: "About your routine",
                subtitle: "Two quick questions so we can pace your plan."
            )

            VStack(alignment: .leading, spacing: 9) {
                Text("SESSIONS PER WEEK")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Theme.secondary)
                    .tracking(0.7)
                HStack(spacing: 8) {
                    ForEach(frequencies, id: \.self) { count in
                        let selected = viewModel.sessionsPerWeek == count
                        Button {
                            viewModel.sessionsPerWeek = count
                        } label: {
                            Text("\(count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(selected ? .white : Theme.onSurface)
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(selected ? Theme.primary : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 11)
                                        .stroke(selected ? Theme.primary : Theme.outlineVariant, lineWidth: 1)
                                )
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 9) {
                Text("WEIGHT — \(Int(viewModel.weightKg)) KG")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Theme.secondary)
                    .tracking(0.7)
                Slider(value: $viewModel.weightKg, in: 35...150, step: 1)
                    .tint(Theme.primary)
            }

            PrimaryOnboardingButton(title: "Continue") {
                viewModel.continueToIssues()
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Step 3: Describe pain & issues (AI)

private struct DescribeIssuesStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            StepTitle(
                title: "What's bothering you?",
                subtitle: "Describe any pain or issues you've been facing — our AI will pick exercises that target them."
            )

            TextEditor(text: $viewModel.painDescription)
                .font(.system(size: 15))
                .scrollContentBackground(.hidden)
                .padding(12)
                .frame(height: 160)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Theme.outlineVariant, lineWidth: 1)
                )
                .overlay(alignment: .topLeading) {
                    if viewModel.painDescription.isEmpty {
                        Text("e.g. My right shoulder has been stiff since surgery, and my neck aches after long days at a desk…")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.outline)
                            .padding(18)
                            .allowsHitTesting(false)
                    }
                }

            PrimaryOnboardingButton(
                title: viewModel.isLoading ? "Building your plan…" : "Get My Plan",
                isLoading: viewModel.isLoading,
                disabled: viewModel.painDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ) {
                Task { await viewModel.generatePlan() }
            }
        }
    }
}

// MARK: - Step 4: Your plan

private struct PlanStepView: View {
    var viewModel: OnboardingViewModel
    var onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StepTitle(title: "Your starting plan", subtitle: viewModel.planSummary)

            ForEach(viewModel.recommendations, id: \.self) { rec in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.success)
                        .padding(.top, 2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(rec.exercise)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Theme.onSurface)
                        Text(rec.reason)
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.secondary)
                            .lineSpacing(2)
                    }
                    Spacer()
                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Theme.outlineVariant.opacity(0.6), lineWidth: 1)
                )
            }

            PrimaryOnboardingButton(title: "Start Recovering", action: onComplete)
                .padding(.top, 10)
        }
    }
}

// MARK: - Shared pieces

private struct StepTitle: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(Theme.onSurface)
                .tracking(-0.5)
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(Theme.secondary)
                .lineSpacing(3)
        }
        .padding(.bottom, 8)
    }
}

private struct ChoiceCard: View {
    var icon: String
    var title: String
    var subtitle: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.primary)
                    )
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.onSurface)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.outline)
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Theme.outlineVariant.opacity(0.7), lineWidth: 1)
            )
        }
    }
}

private struct PrimaryOnboardingButton: View {
    var title: String
    var isLoading = false
    var disabled = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white)
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(disabled || isLoading ? Theme.primary.opacity(0.5) : Theme.primary)
            .clipShape(RoundedRectangle(cornerRadius: 13))
        }
        .disabled(disabled || isLoading)
    }
}
