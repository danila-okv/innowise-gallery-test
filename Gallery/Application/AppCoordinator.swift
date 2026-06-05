import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }
    
    func start() {
        let galleryNavController = GalleryNavController()
        galleryNavController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        let favoritesNavController = FavoritesNavController()
        favoritesNavController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        tabBarController.viewControllers = [galleryNavController, favoritesNavController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
