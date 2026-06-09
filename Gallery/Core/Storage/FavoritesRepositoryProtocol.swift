protocol FavoritesRepositoryProtocol {
    func add(_ photo: Photo) throws
    func remove(id: String) throws
    func isFavorite(id: String) throws -> Bool
    func toggle(_ photo: Photo) throws -> Bool
    func fetchAll() throws -> [Photo]
}
