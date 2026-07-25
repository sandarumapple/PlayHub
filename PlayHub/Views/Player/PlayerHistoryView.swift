import SwiftUI

struct PlayerHistoryView: View {
    @StateObject private var vm = StatsVM()

    private var savedLocations: [GameSession] {
        var seen = Set<String>()
        return vm.sessions.reversed().filter { session in
            guard let latitude = session.latitude, let longitude = session.longitude else { return false }
            return seen.insert(String(format: "%.4f,%.4f", latitude, longitude)).inserted
        }
    }

    var body: some View {
        ZStack {
            ArcadeBackdrop(accent: .mint)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    if vm.sessions.isEmpty {
                        emptyState
                    } else {
                        locationsSection
                        historySection
                    }
                }
                .padding(20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Game History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { vm.load() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your game journey")
                .font(.system(size: 29, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("Every score, game and saved place in one view.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.62))
        }
    }

    private var locationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Played locations", systemImage: "mappin.and.ellipse")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            if savedLocations.isEmpty {
                Text("No locations were saved with these games. Open the Map tab and tap Find Me before playing to save your next location.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.64))
                    .padding(16)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(savedLocations) { session in locationCard(session) }
                    }
                }
            }
        }
    }

    private func locationCard(_ session: GameSession) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: "location.fill")
                .foregroundStyle(.mint)
                .font(.headline)
            Text("Saved play location")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
            Text("Last played " + session.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.58))
            mapLink(for: session)
        }
        .frame(width: 200, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.white.opacity(0.12), lineWidth: 1) }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All games")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            LazyVStack(spacing: 12) {
                ForEach(vm.sessions.reversed()) { session in sessionCard(session) }
            }
        }
    }

    private func sessionCard(_ session: GameSession) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon(for: session.mode))
                .font(.title3.weight(.bold))
                .foregroundStyle(.mint)
                .frame(width: 48, height: 48)
                .background(.mint.opacity(0.15), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 5) {
                Text(session.mode.rawValue).font(.headline.weight(.bold)).foregroundStyle(.white)
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption).foregroundStyle(.white.opacity(0.58))
                if session.latitude != nil, session.longitude != nil {
                    mapLink(for: session)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(session.score)").font(.title2.weight(.bold)).foregroundStyle(.white)
                Text("POINTS").font(.caption2.weight(.bold)).tracking(0.7).foregroundStyle(.white.opacity(0.52))
            }
        }
        .padding(15)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.white.opacity(0.10), lineWidth: 1) }
    }

    private var emptyState: some View {
        ContentUnavailableView("No games yet", systemImage: "gamecontroller", description: Text("Play a game to start building your history."))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 340)
    }

    private func mapLink(for session: GameSession) -> some View {
        guard let latitude = session.latitude,
              let longitude = session.longitude,
              let url = URL(string: "https://maps.apple.com/?ll=\(latitude),\(longitude)&q=PlayHub%20game") else {
            return AnyView(EmptyView())
        }

        return AnyView(
            Link(destination: url) {
                Label("View on Map", systemImage: "map.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.mint)
                    .padding(.top, 2)
            }
        )
    }

    private func icon(for mode: GameMode) -> String {
        switch mode {
        case .tapFrenzy: return "hand.tap.fill"
        case .lightItUp: return "lightbulb.fill"
        case .quizRush: return "brain.head.profile"
        }
    }
}
