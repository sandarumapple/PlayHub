import Foundation

enum GameDifficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .easy: return "leaf.fill"
        case .medium: return "flame.fill"
        case .hard: return "bolt.fill"
        }
    }

    var colorName: String {
        switch self {
        case .easy: return "mint"
        case .medium: return "orange"
        case .hard: return "pink"
        }
    }

    var apiValue: String { rawValue.lowercased() }

    var roundDuration: Int {
        switch self { case .easy: 15; case .medium: 10; case .hard: 7 }
    }

    var lightRoundDuration: Int {
        switch self { case .easy: 75; case .medium: 60; case .hard: 45 }
    }

    var lightSpeedMultiplier: Double {
        switch self { case .easy: 1.3; case .medium: 1; case .hard: 0.72 }
    }

    var questionCount: Int {
        switch self { case .easy: 8; case .medium: 10; case .hard: 12 }
    }
}
