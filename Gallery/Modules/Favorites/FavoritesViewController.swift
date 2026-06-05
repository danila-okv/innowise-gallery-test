import UIKit


final class FavoritesViewController: UIViewController {
    weak var coordinator: FavoritesCoordinatorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
    }
}
