import Foundation

struct Photo: Codable, Hashable {
    let id: String
    let description: String?
    let altDescription: String?
    let createdAt: Date
    let urls: PhotoURLs
    let user: PhotoUser
}

struct PhotoURLs: Codable, Hashable {
    let full, regular, small: String
}

struct PhotoUser: Codable, Hashable {
    let name: String
}
