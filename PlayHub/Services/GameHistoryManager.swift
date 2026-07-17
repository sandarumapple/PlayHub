import Foundation


final class GameHistoryManager {


    static let shared = GameHistoryManager()


    private let key = "gameHistory"



    private init() {}



    func saveSession(
        _ session: GameSession
    ) {


        var history = getSessions()


        history.append(session)


        StorageManager.shared.save(
            history,
            key: key
        )
    }



    func getSessions() -> [GameSession] {


        return StorageManager.shared.load(
            [GameSession].self,
            key: key
        ) ?? []
    }



    func clearHistory() {

        StorageManager.shared.remove(
            key: key
        )
    }
}
