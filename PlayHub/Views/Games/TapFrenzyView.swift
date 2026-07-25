import SwiftUI

struct TapFrenzyView: View {
    @StateObject private var vm: TapFrenzyVM
    let difficulty: GameDifficulty
    @State private var buttonSize: CGFloat = 184
    @State private var buttonPosition = CGSize.zero
    @State private var pulse = false

    init(difficulty: GameDifficulty = .medium) {
        self.difficulty = difficulty
        _vm = StateObject(wrappedValue: TapFrenzyVM(difficulty: difficulty))
    }

    var body: some View {
        ZStack {
            ArcadeBackdrop(accent: .white)
            VStack(spacing: 20) {
                gameHeader(title: "Tap Frenzy", eyebrow: "\(difficulty.rawValue.uppercased()) · \(difficulty.roundDuration) SECOND SPRINT", accent: .white)
                HStack(spacing: 12) { stat("hand.tap.fill", "SCORE", "\(vm.score)"); stat("timer", "TIME", "\(vm.time)s") }
                if vm.gameOver { ResultView(title: "Tap Frenzy", score: vm.score, highScore: vm.highScore, playAgain: resetGame) }
                else {
                    Spacer()
                    Button { vm.tap(); moveButton(); shrinkButton() } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "hand.tap.fill").font(.title).foregroundStyle(.white.opacity(0.8))
                            Text("TAP").font(.system(size: 30, weight: .black, design: .rounded)).foregroundStyle(.white)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        .background(RadialGradient(colors: [.white.opacity(0.15), .clear], center: .topLeading, startRadius: 0, endRadius: buttonSize), in: Circle())
                        .background(LinearGradient(colors: [PlayHubTheme.blue, PlayHubTheme.navyLight], startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle())
                        .shadow(color: .white.opacity(0.3), radius: pulse ? 34 : 16)
                        .scaleEffect(pulse ? 1.04 : 1)
                    }
                    .offset(buttonPosition).animation(.spring(response: 0.32, dampingFraction: 0.64), value: buttonPosition)
                    Spacer()
                    VStack(spacing: 12) {
                        Text("COMBO ×\(vm.combo)").font(.headline.weight(.bold)).foregroundStyle(.white)
                        Text(vm.doublePoints ? "DOUBLE POINTS ACTIVE" : "Bonus burst doubles your next taps")
                            .font(.caption.weight(.medium)).foregroundStyle(.white.opacity(vm.doublePoints ? 1 : 0.55))
                        Button { vm.activateDoublePoints() } label: { Label("Bonus Burst", systemImage: "bolt.fill").font(.subheadline.weight(.bold)).padding(.horizontal, 18).padding(.vertical, 11) }
                            .buttonStyle(.borderedProminent).tint(.white).disabled(vm.doublePoints)
                    }
                    .frame(maxWidth: .infinity).padding(18).background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
            }.padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if !vm.isStarted { vm.start() }; pulse = true }
    }
    private func gameHeader(title: String, eyebrow: String, accent: Color) -> some View { VStack(spacing: 5) { Text(eyebrow).font(.caption.weight(.bold)).tracking(1.5).foregroundStyle(accent); Text(title).font(.system(size: 30, weight: .bold, design: .rounded)).foregroundStyle(.white) } }
    private func stat(_ icon: String, _ label: String, _ value: String) -> some View { HStack(spacing: 11) { Image(systemName: icon).foregroundStyle(.white); VStack(alignment: .leading, spacing: 2) { Text(label).font(.caption2.weight(.bold)).tracking(1).foregroundStyle(.white.opacity(0.55)); Text(value).font(.title3.weight(.bold)).foregroundStyle(.white) }; Spacer() }.padding(15).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous)) }
    private func resetGame() { buttonSize = 184; buttonPosition = .zero; vm.restart() }
    private func moveButton() { let range: ClosedRange<CGFloat> = difficulty == .easy ? -60...60 : (difficulty == .medium ? -95...95 : -125...125); buttonPosition = CGSize(width: .random(in: range), height: .random(in: range)) }
    private func shrinkButton() { let minimum: CGFloat = difficulty == .easy ? 118 : (difficulty == .medium ? 96 : 82); let change: CGFloat = difficulty == .hard ? 6 : 4; if buttonSize > minimum { buttonSize -= change } }
}
