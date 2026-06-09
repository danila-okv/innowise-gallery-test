import CoreData

final class FavoritesRepository: FavoritesRepositoryProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func add(_ photo: Photo) throws {
        guard try !isFavorite(id: photo.id) else { return }
        
        let favorite = FavoritePhoto(context: context)
        favorite.id = photo.id
        favorite.photoDescription = photo.description ?? photo.altDescription ?? nil
        favorite.createdAt = photo.createdAt
        favorite.smallURL = photo.urls.small
        favorite.regularURL = photo.urls.regular
        favorite.fullURL = photo.urls.full
        try context.save()
    }
    
    func remove(id: String) throws {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let matches = try context.fetch(request)
        matches.forEach { context.delete($0) }
        try context.save()
    }
    
    func isFavorite(id: String) throws -> Bool {
        let request = FavoritePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try context.count(for: request) > 0
    }
    
    func toggle(_ photo: Photo) throws -> Bool {
        if try isFavorite(id: photo.id) {
            try remove(id: photo.id)
            return false
        }
        try add(photo)
        return true
    }
    
    func fetchAll() throws -> [Photo] {
        let request = FavoritePhoto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let favorites = try context.fetch(request)
        return favorites.map { mapToPhoto($0) }
    }
    
    private func mapToPhoto(_ favorite: FavoritePhoto) -> Photo {
        Photo(
            id: favorite.id,
            description: favorite.photoDescription,
            altDescription: nil,
            createdAt: favorite.createdAt,
            urls: PhotoURLs(
                full: favorite.fullURL,
                regular: favorite.regularURL,
                small: favorite.smallURL
            ),
            user: PhotoUser(name: favorite.authorName)
        )
    }
}
