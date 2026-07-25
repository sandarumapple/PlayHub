import SwiftUI

struct AddPlayerView: View {
    @ObservedObject var vm: PlayerVM
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @FocusState private var nameFieldFocused: Bool

    private var cleanName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        NavigationStack {
            ZStack {
                ArcadeBackdrop(accent: .mint)

                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 68, weight: .medium))
                        .foregroundStyle(.mint)
                        .frame(width: 120, height: 120)
                        .background(.white.opacity(0.11), in: Circle())
                        .overlay { Circle().stroke(.white.opacity(0.13), lineWidth: 1) }

                    VStack(spacing: 8) {
                        Text("Create your player")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Your scores and played locations will be saved here.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.64))
                    }

                    VStack(alignment: .leading, spacing: 9) {
                        Text("PLAYER NAME")
                            .font(.caption.weight(.bold))
                            .tracking(1)
                            .foregroundStyle(.white.opacity(0.6))
                        TextField("Enter your name", text: $name)
                            .focused($nameFieldFocused)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                            .onSubmit(createPlayer)
                            .padding(16)
                            .foregroundStyle(.white)
                            .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay { RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.white.opacity(0.15), lineWidth: 1) }
                    }
                    .padding(.top, 8)

                    Button(action: createPlayer) {
                        Label("Create Player", systemImage: "arrow.right.circle.fill")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                    }
                    .disabled(cleanName.isEmpty)
                    .foregroundStyle(cleanName.isEmpty ? .white.opacity(0.45) : PlayHubTheme.navy)
                    .background(cleanName.isEmpty ? .white.opacity(0.10) : .mint, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("New Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear { nameFieldFocused = true }
    }

    private func createPlayer() {
        guard !cleanName.isEmpty else { return }
        vm.addPlayer(name: cleanName)
        NotificationCenter.default.post(name: .playerChanged, object: nil)
        dismiss()
    }
}
