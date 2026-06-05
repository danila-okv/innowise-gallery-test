import UIKit


final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }
    
    func start() {
        let galleryCoordinator = GalleryCoordinator()
        childCoordinators.append(galleryCoordinator)
        galleryCoordinator.start()
        
        let favoritesCoordinator = FavoritesCoordinator()
        childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.start()
        
        tabBarController.viewControllers = [
            galleryCoordinator.navigationController,
            favoritesCoordinator.navigationController
        ]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
