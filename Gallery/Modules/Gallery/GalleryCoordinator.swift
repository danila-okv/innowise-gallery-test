import UIKit


final class GalleryCoordinator: NavigationCoordinator, GalleryCoordinatorProtocol {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
    }
    
    func start() {
        let vc = GalleryViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
}


protocol GalleryCoordinatorProtocol: AnyObject { }
