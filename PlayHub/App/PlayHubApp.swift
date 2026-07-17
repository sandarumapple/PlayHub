import SwiftUI

@main
struct PlayHubApp: App {

    @StateObject private var playerVM = PlayerVM()

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(playerVM)

        }

    }

}
