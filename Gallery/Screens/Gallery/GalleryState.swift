enum GalleryState {
    case idle
    case loading
    case loaded(photos: [Photo], isLoadingMore: Bool)
    case error(String)
}
