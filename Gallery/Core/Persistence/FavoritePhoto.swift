import CoreData

@objc(FavoritePhoto)
final class FavoritePhoto: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var smallURL: String
    @NSManaged var regularURL: String
    @NSManaged var fullURL: String
    @NSManaged var photoDescription: String?
    @NSManaged var authorName: String
    @NSManaged var createdAt: Date
}

extension FavoritePhoto {
    static func fetchRequest() -> NSFetchRequest<FavoritePhoto> {
        NSFetchRequest<FavoritePhoto>(entityName: "FavoritePhoto")
    }
}
