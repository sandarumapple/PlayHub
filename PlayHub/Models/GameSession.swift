//
//  GameSession.swift
//

import Foundation


struct GameSession: Identifiable, Codable {

    var id = UUID()

    var playerName: String

    var mode: GameMode

    var score: Int

    var date: Date


    init(
        playerName: String,
        mode: GameMode,
        score: Int
    ) {

        self.playerName = playerName
        self.mode = mode
        self.score = score
        self.date = Date()
    }
}
