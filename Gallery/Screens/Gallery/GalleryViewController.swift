import UIKit
import SnapKit
import Combine

final class GalleryViewController: UIViewController {
    weak var coordinator: GalleryCoordinatorProtocol?
    private let viewModel: GalleryViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    private weak var loadingFooter: LoadingFooterView?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private enum Section {
        case main
    }
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureDataSource()
        bind()
        viewModel.loadInitial()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        setupCollectionView()
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )
        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.reuseIdentifier
        )
        collectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let columns: CGFloat = 3.0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/columns),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0/columns)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [footer]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - DataSource configuration
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.reuseIdentifier,
                for: indexPath
            ) as? PhotoCell
            let isFavorite = self?.viewModel.isFavorite(photo)
            cell?.configure(with: photo, isFavorite: isFavorite)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.reuseIdentifier,
                for: indexPath
            ) as? LoadingFooterView
            self?.loadingFooter = footer
            if case .loaded(_, let isLoadingMore) = self?.viewModel.state, isLoadingMore {
                footer?.startAnimating()
            } else {
                footer?.stopAnimating()
            }
            return footer
        }
    }
    
    private func applySnapshot(_ photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Combine binding
    private func bind() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellable)
    }

    private func render(_ state: GalleryState) {
        switch state {
        case .idle:
            break
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded(let photos, let isLoadingMore):
            loadingIndicator.stopAnimating()
            applySnapshot(photos)
            if isLoadingMore {
                loadingFooter?.startAnimating()
            } else {
                loadingFooter?.stopAnimating()
            }
        case .error(let message):
            print("Error: \(message)")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let totalItems = dataSource.snapshot().numberOfItems
        let threshold = 6
        if indexPath.item >= totalItems - threshold {
            viewModel.loadNextPage()
        }
    }
}
