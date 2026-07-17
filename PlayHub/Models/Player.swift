//
// Player.swift
// PlayHub
//

import Foundation


struct Player: Identifiable, Codable {


    var id: UUID = UUID()


    var name: String


    var createdDate: Date = Date()


    var totalGames: Int = 0


    var bestScore: Int = 0



    // MARK: Location

    var latitude: Double?

    var longitude: Double?

    var locationName: String?




    init(
        name: String
    ) {

        self.name = name

    }

}
