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

    // A game keeps the player's saved location at the moment it was played.
    // These are optional so existing saved history continues to decode.
    var latitude: Double?
    var longitude: Double?


    init(
        playerName: String,
        mode: GameMode,
        score: Int,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {

        self.playerName = playerName
        self.mode = mode
        self.score = score
        self.date = Date()
        self.latitude = latitude
        self.longitude = longitude
    }
}
