import SwiftUI

struct GameSetupView: View {
    let game: GameMode
    @State private var difficulty: GameDifficulty = .medium

    var body: some View {
        ZStack {
            ArcadeBackdrop(accent: accent)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    instructions
                    difficultyPicker
                    NavigationLink { destination } label: {
                        Label("Start \(game.rawValue)", systemImage: "play.fill")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .foregroundStyle(PlayHubTheme.navy)
                            .background(.white, in: RoundedRectangle(cornerRadius: 19, style: .continuous))
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
        }
        .navigationTitle("Game setup")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: game.icon)
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(accent)
            Text(game.rawValue)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("Read the rules, pick a challenge, then jump in.")
                .foregroundStyle(.white.opacity(0.68))
        }
    }

    private var instructions: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label("How to play", systemImage: "questionmark.circle.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            ForEach(rules, id: \.self) { rule in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(accent)
                    Text(rule).font(.subheadline).foregroundStyle(.white.opacity(0.82))
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var difficultyPicker: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text("Choose difficulty").font(.headline.weight(.bold)).foregroundStyle(.white)
            ForEach(GameDifficulty.allCases) { option in
                Button { difficulty = option } label: {
                    HStack(spacing: 13) {
                        Image(systemName: option.icon).frame(width: 24).foregroundStyle(color(for: option))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(option.rawValue).font(.headline).foregroundStyle(.white)
                            Text(difficultyDetail(for: option)).font(.caption).foregroundStyle(.white.opacity(0.58))
                        }
                        Spacer()
                        Image(systemName: difficulty == option ? "checkmark.circle.fill" : "circle")
                            .font(.title3).foregroundStyle(difficulty == option ? accent : .white.opacity(0.4))
                    }
                    .padding(15)
                    .background(difficulty == option ? accent.opacity(0.18) : .white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay { RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(difficulty == option ? accent.opacity(0.75) : .white.opacity(0.09), lineWidth: 1) }
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder private var destination: some View {
        switch game {
        case .tapFrenzy: TapFrenzyView(difficulty: difficulty)
        case .lightItUp: LightItUpView(difficulty: difficulty)
        case .quizRush: QuizRushView(difficulty: difficulty)
        }
    }

    private var rules: [String] {
        switch game {
        case .tapFrenzy:
            return ["Tap the target as quickly as you can.", "Build your combo to earn more points per tap.", "Use Bonus Burst to double points for two seconds."]
        case .lightItUp:
            return ["Tap every glowing tile before the light moves.", "The grid grows and the lights speed up as the round goes on.", "Missing a tile does not end the round—keep your focus."]
        case .quizRush:
            return ["Choose the correct answer for each question.", "Correct answers build a streak and add bonus points.", "A wrong answer breaks the streak and costs five points."]
        }
    }

    private var accent: Color {
        .white
    }

    private func color(for option: GameDifficulty) -> Color {
        .white
    }

    private func difficultyDetail(for option: GameDifficulty) -> String {
        switch (game, option) {
        case (.tapFrenzy, .easy): "15 seconds and a slower target"
        case (.tapFrenzy, .medium): "10-second standard sprint"
        case (.tapFrenzy, .hard): "7 seconds and a faster-moving target"
        case (.lightItUp, .easy): "75 seconds with slower lights"
        case (.lightItUp, .medium): "60-second standard challenge"
        case (.lightItUp, .hard): "45 seconds with faster lights"
        case (.quizRush, .easy): "8 easier questions"
        case (.quizRush, .medium): "10 medium questions"
        case (.quizRush, .hard): "12 tougher questions"
        }
    }
}
