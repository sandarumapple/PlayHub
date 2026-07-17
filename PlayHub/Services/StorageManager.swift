import Foundation


final class StorageManager {


    static let shared = StorageManager()


    private init() {}



    func save<T: Codable>(
        _ object: T,
        key: String
    ) {

        if let data = try? JSONEncoder().encode(object) {

            UserDefaults.standard.set(
                data,
                forKey: key
            )
        }
    }



    func load<T: Codable>(
        _ type: T.Type,
        key: String
    ) -> T? {


        guard let data = UserDefaults.standard.data(
            forKey: key
        )
        else {
            return nil
        }


        return try? JSONDecoder().decode(
            type,
            from: data
        )
    }



    func remove(key: String) {

        UserDefaults.standard.removeObject(
            forKey: key
        )
    }
}
