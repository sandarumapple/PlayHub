import SwiftUI

@main
struct PlayHubApp: App {

    @StateObject private var playerVM = PlayerVM()

    init() {
        NotificationService.shared.configure()
    }

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(playerVM)

        }

    }

}
