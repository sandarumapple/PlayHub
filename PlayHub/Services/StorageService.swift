//
//  StorageService.swift
//  PlayHub
//

import Foundation


final class StorageService {


    static let shared =
    StorageService()


    private init(){}




    // MARK: Keys


    private let playerKey =
    "playhub_player"


    private let historyKey =
    "playhub_history"


    private let playersKey =
    "playhub_players"


    private let currentPlayerKey =
    "current_player_id"








    // MARK: SINGLE PLAYER SAVE


    func savePlayer(
        _ player: Player
    ) {

        if let data =
            try? JSONEncoder().encode(player)
        {

            UserDefaults.standard.set(
                data,
                forKey: playerKey
            )

        }

    }







    func loadPlayer()
    -> Player? {


        guard let data =
                UserDefaults.standard.data(
                    forKey: playerKey
                )

        else {

            return nil

        }



        return try?
        JSONDecoder()
            .decode(
                Player.self,
                from: data
            )

    }









    // MARK: MULTIPLE PLAYERS



    func loadPlayers()
    -> [Player] {


        guard let data =
                UserDefaults.standard.data(
                    forKey: playersKey
                )

        else {

            return []

        }



        return
        (try?
            JSONDecoder()
                .decode(
                    [Player].self,
                    from: data
                )
        )
        ??
        []

    }







    func savePlayers(
        _ players:[Player]
    ) {


        if let data =
            try? JSONEncoder()
                .encode(players)
        {


            UserDefaults.standard.set(
                data,
                forKey: playersKey
            )


        }

    }









    // MARK: ADD PLAYER



    func addPlayer(
        name:String
    )
    -> Player {


        var players =
        loadPlayers()



        let player =
        Player(
            name:name
        )



        players.append(
            player
        )



        savePlayers(
            players
        )


        return player

    }









    // MARK: CURRENT PLAYER



    func currentPlayer()
    -> Player? {


        guard let id =
                UserDefaults.standard.string(
                    forKey: currentPlayerKey
                )

        else {

            return nil

        }




        return loadPlayers()
            .first {

                $0.id.uuidString == id

            }


    }







    func setCurrentPlayer(
        _ player: Player
    ) {


        UserDefaults.standard.set(
            player.id.uuidString,
            forKey: currentPlayerKey
        )


        savePlayer(player)


    }








    func logout(){


        UserDefaults.standard.removeObject(
            forKey: currentPlayerKey
        )

    }









    // MARK: UPDATE PLAYER


    func updatePlayer(
        _ player: Player
    ) {


        var players =
        loadPlayers()



        if let index =
            players.firstIndex(
                where: {
                    $0.id == player.id
                }
            )
        {


            players[index] =
            player



            savePlayers(
                players
            )


            // save latest player
            savePlayer(
                player
            )


            print(
                "PLAYER UPDATED:",
                player.name
            )


        }
        else
        {


            print(
                "PLAYER NOT FOUND"
            )


        }


    }









    // MARK: GAME SAVE


    func saveGame(
        mode: GameMode,
        score: Int
    ) {


        guard var player =
                currentPlayer()

        else {

            return

        }




        let session =
        GameSession(
            playerName: player.name,
            mode: mode,
            score: score
        )



        saveSession(
            session
        )



        player.totalGames += 1



        if score > player.bestScore {


            player.bestScore = score


        }



        updatePlayer(
            player
        )



        saveHighScore(
            mode: mode,
            score: score
        )


    }









    // MARK: SESSION HISTORY


    func saveSession(
        _ session: GameSession
    ) {


        var history =
        loadHistory()



        history.append(
            session
        )



        if let data =
            try? JSONEncoder()
                .encode(history)
        {


            UserDefaults.standard.set(
                data,
                forKey: historyKey
            )

        }

    }







    func loadHistory()
    -> [GameSession] {


        guard let data =
                UserDefaults.standard.data(
                    forKey: historyKey
                )

        else {

            return []

        }




        return
        (try?
            JSONDecoder()
                .decode(
                    [GameSession].self,
                    from:data
                )
        )
        ??
        []

    }









    // MARK: HIGH SCORE



    func saveHighScore(
        mode: GameMode,
        score: Int
    ) {


        let key =
        "highscore_\(mode.rawValue)"



        let old =
        UserDefaults.standard.integer(
            forKey:key
        )



        if score > old {


            UserDefaults.standard.set(
                score,
                forKey:key
            )

        }

    }







    func highScore(
        mode: GameMode
    )
    -> Int {


        UserDefaults.standard.integer(
            forKey:
                "highscore_\(mode.rawValue)"
        )


    }









    // MARK: DELETE PLAYER



    func deletePlayer(
        id: UUID
    ) {


        var players =
        loadPlayers()



        players.removeAll {
            $0.id == id
        }



        savePlayers(
            players
        )


    }









    // MARK: CLEAR HISTORY



    func clearHistory(){


        UserDefaults.standard.removeObject(
            forKey: historyKey
        )


    }









    // MARK: CLEAR ALL DATA



    func clearAllData(){


        UserDefaults.standard.removeObject(
            forKey: playerKey
        )


        UserDefaults.standard.removeObject(
            forKey: playersKey
        )


        UserDefaults.standard.removeObject(
            forKey: currentPlayerKey
        )


        UserDefaults.standard.removeObject(
            forKey: historyKey
        )



        for mode in GameMode.allCases {


            UserDefaults.standard.removeObject(
                forKey:
                    "highscore_\(mode.rawValue)"
            )

        }

    }


}
