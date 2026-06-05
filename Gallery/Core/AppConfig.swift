import Foundation

enum AppConfig {
    static let unsplashAccessKey: String = {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = dict["UnsplashAcessKey"] as? String,
            !key.isEmpty
        else {
            fatalError("Missing UnsplashAccessKey. Copy Secrets.example.plist to Secrets.plist and add your key.")
        }
        return key
    }()
}
