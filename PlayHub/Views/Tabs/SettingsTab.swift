import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject private var vm: PlayerVM
    @State private var showAddPlayer = false
    @State private var showHistoryAlert = false
    @State private var showDeleteAlert = false
    @State private var showLogoutAlert = false
    @State private var showNotificationAlert = false
    @State private var notificationAlertMessage = ""
    @AppStorage("gameReminderEnabled") private var gameReminderEnabled = false
    @AppStorage("gameReminderTime") private var gameReminderTime = Date()

    var body: some View {
        NavigationStack {
            ZStack {
                ArcadeBackdrop(accent: .white)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        heading
                        playerCard
                        lastPlayedLocation
                        preferences
                        players
                        data
                        about
                    }
                    .padding(.horizontal, 20).padding(.bottom, 110)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showAddPlayer) { AddPlayerView(vm: vm) }
            .onAppear { vm.refresh(); if gameReminderEnabled { scheduleReminder() } }
            .onReceive(NotificationCenter.default.publisher(for: .gameSaved)) { _ in vm.refresh() }
            .onReceive(NotificationCenter.default.publisher(for: .playerUpdated)) { _ in vm.refresh() }
            .onReceive(NotificationCenter.default.publisher(for: .gameHistoryCleared)) { _ in vm.refresh() }
            .alert("Sign out?", isPresented: $showLogoutAlert) { Button("Cancel", role: .cancel) {}; Button("Logout", role: .destructive) { vm.logout() } } message: { Text("You can choose this player again from the player screen.") }
            .alert("Clear game history?", isPresented: $showHistoryAlert) { Button("Cancel", role: .cancel) {}; Button("Clear", role: .destructive) { StorageService.shared.clearHistory(); vm.refresh() } } message: { Text("All saved game sessions will be removed.") }
            .alert("Delete all data?", isPresented: $showDeleteAlert) { Button("Cancel", role: .cancel) {}; Button("Delete", role: .destructive) { StorageService.shared.clearAllData(); vm.refresh() } } message: { Text("This permanently deletes players, scores, and game history.") }
            .alert("Game reminder", isPresented: $showNotificationAlert) { Button("OK", role: .cancel) {} } message: { Text(notificationAlertMessage) }
        }
    }

    private var heading: some View { VStack(alignment: .leading, spacing: 5) { Text("ACCOUNT & APP").font(.caption.weight(.bold)).tracking(1.6).foregroundStyle(.white); Text("Settings").font(.system(size: 34, weight: .bold, design: .rounded)).foregroundStyle(.white); Text("Personalize your PlayHub experience.").font(.subheadline).foregroundStyle(.white.opacity(0.62)) }.padding(.top, 14) }

    private var playerCard: some View { section("Current player", icon: "person.fill") { if let player = vm.player { HStack(spacing: 15) { Image(systemName: "person.fill").font(.title2.weight(.bold)).foregroundStyle(.white).frame(width: 56, height: 56).background(LinearGradient(colors: [.mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle()); VStack(alignment: .leading, spacing: 5) { Text(player.name).font(.title3.weight(.bold)).foregroundStyle(.white); Text("\(player.totalGames) games played · Best \(player.bestScore)").font(.caption).foregroundStyle(.white.opacity(0.62)) }; Spacer(); Button { showLogoutAlert = true } label: { Image(systemName: "rectangle.portrait.and.arrow.right").foregroundStyle(.red).frame(width: 40, height: 40).background(.red.opacity(0.12), in: Circle()) } } } else { Label("No player selected", systemImage: "person.crop.circle.badge.questionmark").foregroundStyle(.white.opacity(0.65)) } } }

    private var lastPlayedLocation: some View { section("Last played location", icon: "location.fill") { if let player = vm.player, let latitude = player.latitude, let longitude = player.longitude, let mapURL = URL(string: "https://maps.apple.com/?ll=\(latitude),\(longitude)&q=PlayHub%20saved%20location") { VStack(alignment: .leading, spacing: 16) { HStack(spacing: 13) { Image(systemName: "mappin.and.ellipse").font(.title2).foregroundStyle(.mint).frame(width: 47, height: 47).background(.mint.opacity(0.15), in: RoundedRectangle(cornerRadius: 15, style: .continuous)); VStack(alignment: .leading, spacing: 4) { Text("Location saved").font(.headline.weight(.semibold)).foregroundStyle(.white); Text("Use the map to see this saved position.").font(.caption).foregroundStyle(.white.opacity(0.58)) } }; Link(destination: mapURL) { Label("View saved location on Map", systemImage: "map.fill").font(.subheadline.weight(.bold)).foregroundStyle(.mint).frame(maxWidth: .infinity).padding(.vertical, 13).background(.mint.opacity(0.14), in: RoundedRectangle(cornerRadius: 15, style: .continuous)) } } } else { HStack(spacing: 13) { Image(systemName: "location.slash.fill").foregroundStyle(.white.opacity(0.5)).frame(width: 47, height: 47).background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 15, style: .continuous)); VStack(alignment: .leading, spacing: 4) { Text("No location saved yet").font(.headline.weight(.semibold)).foregroundStyle(.white); Text("Open the Map tab and tap Find Me to save it.").font(.caption).foregroundStyle(.white.opacity(0.58)) } } } } }

    private var preferences: some View { section("Game reminder", icon: "bell.fill") { VStack(spacing: 14) { Toggle(isOn: Binding(get: { gameReminderEnabled }, set: updateReminder)) { VStack(alignment: .leading, spacing: 3) { Text("Daily reminder").font(.subheadline.weight(.semibold)).foregroundStyle(.white); Text(gameReminderEnabled ? "Scheduled every day" : "Turn on to set a play time").font(.caption).foregroundStyle(.white.opacity(0.55)) } }.tint(.mint); if gameReminderEnabled { Divider().overlay(.white.opacity(0.1)); DatePicker("Reminder time", selection: $gameReminderTime, displayedComponents: .hourAndMinute).foregroundStyle(.white).tint(.mint).onChange(of: gameReminderTime) { _, _ in scheduleReminder() } } } } }

    private var players: some View { section("Players", icon: "person.2.fill") { VStack(spacing: 2) { Button { showAddPlayer = true } label: { row("Add new player", icon: "person.badge.plus", color: .mint, showChevron: true) }.buttonStyle(.plain); if !vm.players.isEmpty { Divider().overlay(.white.opacity(0.1)); ForEach(vm.players, id: \.id) { player in Button { vm.selectPlayer(player) } label: { HStack { row(player.name, icon: "person.circle.fill", color: vm.player?.id == player.id ? .mint : .white.opacity(0.7), showChevron: false); if vm.player?.id == player.id { Image(systemName: "checkmark.circle.fill").foregroundStyle(.mint) } }.contentShape(Rectangle()) }.buttonStyle(.plain) } } } } }

    private var data: some View { section("Data management", icon: "externaldrive.fill") { VStack(spacing: 2) { Button { showHistoryAlert = true } label: { row("Clear game history", icon: "clock.arrow.circlepath", color: .orange, showChevron: true) }.buttonStyle(.plain); Divider().overlay(.white.opacity(0.1)); Button { showDeleteAlert = true } label: { row("Delete all data", icon: "trash.fill", color: .red, showChevron: true) }.buttonStyle(.plain) } } }
    private var about: some View { section("About", icon: "info.circle.fill") { HStack { VStack(alignment: .leading, spacing: 3) { Text("PlayHub").font(.subheadline.weight(.semibold)).foregroundStyle(.white); Text("Play · Compete · Improve").font(.caption).foregroundStyle(.white.opacity(0.55)) }; Spacer(); Text("v1.0").font(.caption.weight(.bold)).foregroundStyle(.mint).padding(.horizontal, 10).padding(.vertical, 6).background(.mint.opacity(0.14), in: Capsule()) } } }

    private func section<Content: View>(_ title: String, icon: String, @ViewBuilder content: () -> Content) -> some View { VStack(alignment: .leading, spacing: 11) { Label(title.uppercased(), systemImage: icon).font(.caption.weight(.bold)).tracking(1.1).foregroundStyle(.white.opacity(0.6)); content().padding(17).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous)).overlay { RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(.white.opacity(0.11), lineWidth: 1) } } }
    private func row(_ title: String, icon: String, color: Color, showChevron: Bool) -> some View { HStack(spacing: 12) { Image(systemName: icon).foregroundStyle(color).frame(width: 23); Text(title).font(.subheadline.weight(.medium)).foregroundStyle(.white); Spacer(); if showChevron { Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(.white.opacity(0.35)) } }.padding(.vertical, 8) }
    private func updateReminder(_ enabled: Bool) { gameReminderEnabled = enabled; if enabled { NotificationService.shared.requestPermission { granted in if granted { scheduleReminder() } else { gameReminderEnabled = false; notificationAlertMessage = "Enable notifications for PlayHub in iPhone Settings to receive reminders."; showNotificationAlert = true } } } else { NotificationService.shared.cancelGameReminder() } }
    private func scheduleReminder() { NotificationService.shared.scheduleDailyGameReminder(at: gameReminderTime) { error in if error != nil { gameReminderEnabled = false; notificationAlertMessage = "PlayHub couldn’t schedule your reminder. Please try again."; showNotificationAlert = true } } }
}
