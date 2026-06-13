import UIKit
import SnapKit

final class LoadingFooterView: UICollectionReusableView {
    static let reuseIdentifier = "LoadingFooterView"

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() { indicator.startAnimating() }
    func stopAnimating() { indicator.stopAnimating() }
}
