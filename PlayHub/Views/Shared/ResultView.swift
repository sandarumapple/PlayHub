import SwiftUI

struct ResultView: View {
    var title: String
    var score: Int
    var highScore: Int
    var playAgain: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle().fill(.white.opacity(0.16)).frame(width: 100, height: 100)
                Image(systemName: score >= highScore ? "trophy.fill" : "flag.checkered")
                    .font(.system(size: 39, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(score >= highScore ? "New personal best!" : "Round complete")
                .font(.title2.weight(.bold)).foregroundStyle(.white)
            Text(title.uppercased()).font(.caption.weight(.bold)).tracking(1.5).foregroundStyle(.white.opacity(0.55))
            HStack(spacing: 0) {
                resultMetric("SCORE", "\(score)")
                Divider().overlay(.white.opacity(0.15)).frame(height: 44)
                resultMetric("BEST", "\(highScore)")
            }
            .padding(.vertical, 16)
            .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            Button(action: playAgain) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.headline.weight(.bold)).frame(maxWidth: .infinity).padding(.vertical, 17)
                    .foregroundStyle(PlayHubTheme.navy)
                    .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(.white.opacity(0.15), lineWidth: 1) }
        .padding()
    }

    private func resultMetric(_ label: String, _ value: String) -> some View {
        VStack(spacing: 5) { Text(value).font(.title.weight(.bold)).foregroundStyle(.white); Text(label).font(.caption2.weight(.bold)).tracking(1).foregroundStyle(.white.opacity(0.55)) }
            .frame(maxWidth: .infinity)
    }
}
