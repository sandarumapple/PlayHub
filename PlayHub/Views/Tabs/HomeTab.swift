import SwiftUI

struct HomeTab: View {
    @AppStorage("playerName") private var playerName = ""
    @EnvironmentObject private var playerVM: PlayerVM

    var body: some View {
        NavigationStack {
            ZStack {
                ArcadeBackdrop(accent: .white)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        welcome
                        playerSummary

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("PLAY NOW")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.4)
                                    .foregroundStyle(.white)
                                Text("Choose a challenge")
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                .foregroundStyle(.white.opacity(0.7))
                        }

                        gameCard("Tap Frenzy", subtitle: "Build a wild combo in a rapid sprint", icon: "hand.tap.fill", palette: [PlayHubTheme.navyLight, PlayHubTheme.blue], destination: GameSetupView(game: .tapFrenzy))
                        gameCard("Light It Up", subtitle: "Catch the glow before it fades", icon: "lightbulb.fill", palette: [PlayHubTheme.navyLight, PlayHubTheme.blue], destination: GameSetupView(game: .lightItUp))
                        gameCard("Quiz Rush", subtitle: "A fast, fresh knowledge sprint", icon: "brain.head.profile", palette: [PlayHubTheme.navyLight, PlayHubTheme.blue], destination: GameSetupView(game: .quizRush))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 110)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { playerVM.refresh() }
            .onReceive(NotificationCenter.default.publisher(for: .gameHistoryCleared)) { _ in
                playerVM.refresh()
            }
        }
    }

    private var welcome: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("PLAYHUB")
                    .font(.caption.weight(.heavy))
                    .tracking(2.4)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "bell.badge.fill")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(width: 42, height: 42)
                    .background(.white.opacity(0.1), in: Circle())
            }
            Text("Good to see you,\n\(playerName.isEmpty ? "Player" : playerName).")
                .font(.system(size: 31, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private var playerSummary: some View {
        HStack(spacing: 0) {
            metric(icon: "trophy.fill", label: "BEST SCORE", value: "\(playerVM.player?.bestScore ?? 0)", color: .white)
            Divider().overlay(.white.opacity(0.16)).frame(height: 54)
            metric(icon: "gamecontroller.fill", label: "GAMES PLAYED", value: "\(playerVM.player?.totalGames ?? 0)", color: .white)
        }
        .padding(.vertical, 18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(.white.opacity(0.13), lineWidth: 1) }
    }

    private func metric(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 11) {
            Image(systemName: icon).foregroundStyle(color).font(.title3)
            VStack(alignment: .leading, spacing: 3) {
                Text(label).font(.caption2.weight(.bold)).tracking(0.6).foregroundStyle(.white.opacity(0.52))
                Text(value).font(.title3.weight(.bold)).foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func gameCard<Destination: View>(_ title: String, subtitle: String, icon: String, palette: [Color], destination: Destination) -> some View {
        NavigationLink { destination } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(.white.opacity(0.19), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(.headline.weight(.bold)).foregroundStyle(.white)
                    Text(subtitle).font(.caption).foregroundStyle(.white.opacity(0.76))
                }
                Spacer()
                Image(systemName: "arrow.up.right").font(.headline.weight(.bold)).foregroundStyle(.white)
            }
            .padding(18)
            .background(LinearGradient(colors: palette, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: palette.last?.opacity(0.28) ?? .clear, radius: 18, y: 9)
        }
        .buttonStyle(.plain)
    }
}

struct ArcadeBackdrop: View {
    let accent: Color
    var body: some View {
        ZStack {
            LinearGradient(colors: [PlayHubTheme.navy, PlayHubTheme.navyLight], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().fill(accent.opacity(0.12)).frame(width: 310, height: 310).blur(radius: 100).offset(x: -150, y: -320)
            Circle().fill(.white.opacity(0.06)).frame(width: 290, height: 290).blur(radius: 105).offset(x: 175, y: 310)
        }.ignoresSafeArea()
    }
}
