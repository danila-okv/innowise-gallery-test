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
        let vc = FavoritesViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
}


protocol FavoritesCoordinatorProtocol: AnyObject { }
