//
// PlayerVM.swift
// PlayHub
//

import Foundation
import Combine
import CoreLocation


@MainActor
final class PlayerVM: ObservableObject {


    @Published var players: [Player] = []

    @Published var player: Player?





    init() {

        load()

    }







    // MARK: Load

    func load() {


        players =
        StorageService.shared
            .loadPlayers()



        player =
        StorageService.shared
            .currentPlayer()



        print(
            "CURRENT PLAYER:",
            player?.name ?? "NONE"
        )


    }







    // MARK: Add Player

    func addPlayer(
        name: String
    ) {


        let newPlayer =
        StorageService.shared
            .addPlayer(
                name: name
            )



        StorageService.shared
            .setCurrentPlayer(
                newPlayer
            )



        load()


        print(
            "NEW PLAYER CREATED:",
            newPlayer.name
        )


    }







    // MARK: Select Existing Player

    func selectPlayer(
        _ selectedPlayer: Player
    ) {


        print(
            "SELECTING PLAYER:",
            selectedPlayer.name
        )



        StorageService.shared
            .setCurrentPlayer(
                selectedPlayer
            )



        let check =
        StorageService.shared
            .currentPlayer()



        print(
            "AFTER SELECT:",
            check?.name ?? "NONE"
        )



        load()


    }








    // MARK: Delete Player

    func deletePlayer(
        _ player: Player
    ) {


        StorageService.shared
            .deletePlayer(
                id: player.id
            )



        if self.player?.id == player.id {


            StorageService.shared.logout()


        }



        load()


    }








    // MARK: Logout

    func logout(){


        print(
            "LOGGING OUT"
        )


        StorageService.shared.logout()


        load()


    }








    // MARK: Create Player

    func createPlayer(
        name: String
    ){


        addPlayer(
            name: name
        )


    }







    // MARK: Update Location

    func updateLocation(
        _ location: CLLocation
    ) {


        guard var currentPlayer =
                StorageService.shared.currentPlayer()

        else {

            print(
                "NO CURRENT PLAYER"
            )

            return

        }





        currentPlayer.latitude =
        location.coordinate.latitude



        currentPlayer.longitude =
        location.coordinate.longitude





        currentPlayer.locationName =
        """
        📍 Latitude:
        \(location.coordinate.latitude)

        Longitude:
        \(location.coordinate.longitude)
        """






        StorageService.shared
            .updatePlayer(
                currentPlayer
            )






        self.player =
        currentPlayer





        if let index =
            players.firstIndex(
                where: {
                    $0.id == currentPlayer.id
                }
            )
        {


            players[index] =
            currentPlayer


        }





        NotificationCenter.default.post(
            name: .playerUpdated,
            object: nil
        )



        print(
            "LOCATION UPDATED FOR:",
            currentPlayer.name
        )


    }








    // MARK: Refresh

    func refresh(){


        load()


    }


}








// MARK: Notifications

extension Notification.Name {


    static let playerUpdated =
    Notification.Name(
        "playerUpdated"
    )


    static let gameSaved =
    Notification.Name(
        "gameSaved"
    )


}
