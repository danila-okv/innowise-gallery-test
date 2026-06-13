import Foundation
import Combine

@MainActor
final class GalleryViewModel {
    @Published private(set) var state: GalleryState = .idle
    
    private let networkService: NetworkServiceProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    private var photos: [Photo] = []
    private var currentPage = 1
    private var canLoadMore = true
    private var isFetching = false
    
    private let perPage = 30
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()
    ) {
        self.networkService = networkService
        self.favoritesRepository = favoritesRepository
    }
    
    func loadInitial() {
        photos = []
        currentPage = 1
        canLoadMore = true
        state = .loading
        fetch(reset: true)
    }
    
    func loadNextPage() {
        guard !isFetching, canLoadMore else { return }
        guard case .loaded(let current, _) = state else { return }
        state = .loaded(photos: current, isLoadingMore: true)
        fetch(reset: false)
    }
    
    func isFavorite(_ photo: Photo) -> Bool {
        (try? favoritesRepository.isFavorite(id: photo.id)) ?? false
    }
    
    private func fetch(reset: Bool) {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                let new = try await networkService.fetchPhotos(page: currentPage, perPage: perPage)
                if new.count < perPage { canLoadMore = false }
                photos = reset ? new : photos + new
                currentPage += 1
                state = .loaded(photos: photos, isLoadingMore: false)
            } catch {
                if reset {
                    state = .error(error.localizedDescription)
                } else {
                    state = .loaded(photos: photos, isLoadingMore: false)
                }
            }
            isFetching = false
        }
    }
}
