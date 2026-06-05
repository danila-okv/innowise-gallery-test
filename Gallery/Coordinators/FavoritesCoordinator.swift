import UIKit

final class FavoritesCoordinator: NavigationCoordinator, FavoritesCoordinatorProtocol {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
    }
    
    func start() {
        let favoritesVC = FavoritesViewController()
        favoritesVC.coordinator = self
        navigationController.setViewControllers([favoritesVC], animated: false)
    }
}

protocol FavoritesCoordinatorProtocol: AnyObject { }
