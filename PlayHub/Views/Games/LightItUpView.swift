import SwiftUI

struct LightItUpView: View {
    @StateObject private var vm: LightItUpVM
    let difficulty: GameDifficulty
    @State private var glow = false
    init(difficulty: GameDifficulty = .medium) {
        self.difficulty = difficulty
        _vm = StateObject(wrappedValue: LightItUpVM(difficulty: difficulty))
    }
    var body: some View {
        ZStack {
            ArcadeBackdrop(accent: .white)
            VStack(spacing: 18) {
                VStack(spacing: 5) { Text("\(difficulty.rawValue.uppercased()) · REACTION CHALLENGE").font(.caption.weight(.bold)).tracking(1.5).foregroundStyle(.white); Text("Light It Up").font(.system(size: 30, weight: .bold, design: .rounded)).foregroundStyle(.white) }
                HStack(spacing: 10) { metric("bolt.fill", "SCORE", "\(vm.score)"); metric("timer", "REMAINING", "\(vm.timeRemaining)s"); metric("chart.line.uptrend.xyaxis", "LEVEL", "\(vm.currentLevel)") }
                if vm.gameStarted { grid } else { launch }
            }.padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Round complete", isPresented: $vm.gameOver) { Button("Play Again") { vm.startGame() }; Button("Done", role: .cancel) {} } message: { Text("Score: \(vm.score)\nBest score: \(vm.highScore)") }
    }
    private var launch: some View { VStack(spacing: 24) { Spacer(); ZStack { Circle().fill(.white.opacity(0.14)).frame(width: 180, height: 180).scaleEffect(glow ? 1.18 : 0.9); Image(systemName: "lightbulb.fill").font(.system(size: 70)).foregroundStyle(.white).shadow(color: .white.opacity(0.5), radius: 22) }.animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: glow); Text("Catch every glowing tile\nbefore the light moves on.").font(.title3.weight(.medium)).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.82)); Button { vm.startGame() } label: { Label("Start challenge", systemImage: "play.fill").font(.headline.weight(.bold)).frame(maxWidth: .infinity).padding(.vertical, 17).foregroundStyle(PlayHubTheme.navy).background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous)) }.padding(.horizontal, 24); Spacer() }.onAppear { glow = true } }
    private var grid: some View { VStack(spacing: 16) { HStack { Label("BEST \(vm.highScore)", systemImage: "trophy.fill").font(.caption.weight(.bold)).foregroundStyle(.white); Spacer(); Text("Stay sharp").font(.caption).foregroundStyle(.white.opacity(0.55)) }.padding(.horizontal, 4); LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 13), count: vm.columnCount), spacing: 13) { ForEach(0..<vm.cardCount, id: \.self) { index in let active = vm.activeCards.contains(index); Button { vm.tapCard(index) } label: { RoundedRectangle(cornerRadius: 21, style: .continuous).fill(active ? AnyShapeStyle(.white) : AnyShapeStyle(.white.opacity(0.08))).frame(height: 104).overlay { Image(systemName: active ? "bolt.fill" : "circle").font(.title2.weight(.bold)).foregroundStyle(active ? PlayHubTheme.navy : .white.opacity(0.15)) }.overlay { RoundedRectangle(cornerRadius: 21, style: .continuous).stroke(active ? .white.opacity(0.75) : .white.opacity(0.08), lineWidth: 1) }.shadow(color: active ? .white.opacity(0.5) : .clear, radius: active ? 20 : 0).scaleEffect(active ? 1.04 : 1) }.buttonStyle(.plain).animation(.spring(response: 0.25, dampingFraction: 0.68), value: active) } } }.padding(16).background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 26, style: .continuous)) }
    private func metric(_ icon: String, _ label: String, _ value: String) -> some View { VStack(spacing: 6) { Image(systemName: icon).font(.caption.weight(.bold)).foregroundStyle(.white); Text(value).font(.headline.weight(.bold)).foregroundStyle(.white); Text(label).font(.caption2.weight(.bold)).lineLimit(1).minimumScaleFactor(0.7).foregroundStyle(.white.opacity(0.5)) }.frame(maxWidth: .infinity).padding(.vertical, 12).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 17, style: .continuous)) }
}
