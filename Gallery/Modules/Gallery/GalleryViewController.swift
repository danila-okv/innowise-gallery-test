import UIKit


final class GalleryViewController: UIViewController {
    weak var coordinator: GalleryCoordinatorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
    }
}
