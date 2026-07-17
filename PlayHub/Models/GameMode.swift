//
//  GameMode.swift
//

import Foundation


enum GameMode: String, Codable, CaseIterable, Identifiable {

    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"


    var id: String {
        rawValue
    }


    var icon: String {

        switch self {

        case .tapFrenzy:
            return "hand.tap"

        case .lightItUp:
            return "lightbulb.fill"

        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}
