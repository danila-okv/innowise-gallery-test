import UIKit
import SnapKit

final class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    private var imageTask: Task<Void, Never>?
    private let imageLoader: ImageLoaderProtocol = ImageLoader.shared
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemRed])
        imageView.image = UIImage(systemName: "heart.fill", withConfiguration: config)
        imageView.isHidden = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 3
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.masksToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageView.image = nil
        favoriteImageView.isHidden = true
    }

    func configure(with photo: Photo, isFavorite: Bool) {
        imageTask?.cancel()
        imageView.image = nil
        favoriteImageView.isHidden = !isFavorite
        
        guard let url = URL(string: photo.urls.small) else { return }
        
        imageTask = Task { [weak self] in
            guard let image = try? await self?.imageLoader.loadImage(from: url) else { return }
            guard !Task.isCancelled else { return }
            self?.imageView.image = image
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
}
