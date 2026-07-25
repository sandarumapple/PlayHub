import SwiftUI

struct QuizRushView: View {
    @StateObject private var vm: QuizRushVM
    let difficulty: GameDifficulty
    init(difficulty: GameDifficulty = .medium) {
        self.difficulty = difficulty
        _vm = StateObject(wrappedValue: QuizRushVM(difficulty: difficulty))
    }
    var body: some View {
        ZStack {
            ArcadeBackdrop(accent: .white)
            VStack(spacing: 20) {
                switch vm.state {
                case .loading: ProgressView("Loading your quiz...").tint(.white).foregroundStyle(.white)
                case .failed(let message): failure(message)
                case .playing: game
                case .finished: ResultView(title: "Quiz Rush", score: vm.score, highScore: vm.highScore) { Task { await vm.load() } }
                }
            }.padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }
    private var game: some View { VStack(spacing: 17) { VStack(spacing: 5) { Text("\(difficulty.rawValue.uppercased()) · KNOWLEDGE SPRINT").font(.caption.weight(.bold)).tracking(1.5).foregroundStyle(.white); Text("Quiz Rush").font(.system(size: 30, weight: .bold, design: .rounded)).foregroundStyle(.white) }; HStack(spacing: 12) { stat("star.fill", "SCORE", "\(vm.score)", .white); stat("flame.fill", "STREAK", "\(vm.streak)", .white) }; HStack { Text("QUESTION \(vm.currentIndex + 1) OF \(vm.questions.count)").font(.caption.weight(.bold)).tracking(1).foregroundStyle(.white.opacity(0.6)); Spacer(); Text("+10 base").font(.caption.weight(.bold)).foregroundStyle(.white) }; ProgressView(value: Double(vm.currentIndex + 1), total: Double(max(vm.questions.count, 1))).tint(.white); if let question = vm.currentQuestion { VStack(alignment: .leading, spacing: 14) { Text(question.category.uppercased()).font(.caption.weight(.bold)).tracking(1.1).foregroundStyle(.white); Text(decode(question.question)).font(.title3.weight(.bold)).foregroundStyle(.white).fixedSize(horizontal: false, vertical: true) }.frame(maxWidth: .infinity, alignment: .leading).padding(22).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous)); VStack(spacing: 11) { ForEach(question.answers, id: \.self) { answer in Button { vm.choose(answer: answer) } label: { HStack { Text(decode(answer)).font(.subheadline.weight(.semibold)).multilineTextAlignment(.leading); Spacer(); Image(systemName: "circle").foregroundStyle(.white.opacity(0.45)) }.foregroundStyle(.white).padding(17).frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 17, style: .continuous)).overlay { RoundedRectangle(cornerRadius: 17, style: .continuous).stroke(.white.opacity(0.1), lineWidth: 1) } }.buttonStyle(.plain) } } }; Spacer(minLength: 0) } }
    private func failure(_ message: String) -> some View { VStack(spacing: 18) { Image(systemName: "wifi.exclamationmark").font(.system(size: 48)).foregroundStyle(.white); Text("Couldn’t load the quiz").font(.title2.weight(.bold)).foregroundStyle(.white); Text(message).font(.subheadline).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.65)); Button("Try again") { vm.retry() }.buttonStyle(.borderedProminent).tint(.white) }.padding(30).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous)) }
    private func stat(_ icon: String, _ label: String, _ value: String, _ color: Color) -> some View { HStack(spacing: 10) { Image(systemName: icon).foregroundStyle(color); VStack(alignment: .leading, spacing: 2) { Text(label).font(.caption2.weight(.bold)).tracking(1).foregroundStyle(.white.opacity(0.52)); Text(value).font(.title3.weight(.bold)).foregroundStyle(.white) }; Spacer() }.padding(15).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous)) }
    private func decode(_ text: String) -> String { text.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#039;", with: "'").replacingOccurrences(of: "&amp;", with: "&") }
}
