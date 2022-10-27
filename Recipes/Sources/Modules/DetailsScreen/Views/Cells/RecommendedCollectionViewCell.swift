import Kingfisher
import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecommendedCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecommendedCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier,
                                                            for: indexPath) as? RecommendedCollectionViewCell else {
            return RecommendedCollectionViewCell()
        }
        return cell
    }
    
    // MARK: - Properties
    
    var didPressButton: (() -> Void)?
    
    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private var imageLink: String? {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink ?? ""), placeholder: R.image.placeholder())
        }
    }
    
    private var viewModel: RecommendedImageCollectionViewCellViewModel!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension RecommendedCollectionViewCell {
    func setupCellData(viewModel: RecommendedImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        
        imageLink = viewModel.imageLink
        titleLabel.text = viewModel.name
        
        viewModel.didUpdate = self.setupCellData
    }
}

// MARK: - Private Methods

private extension RecommendedCollectionViewCell {
    
    func configureAppearance() {
        configureRecipeImage()
        configureTitleLabel()
        configureGradient()
        configureUI()
    }
    
    func configureRecipeImage() {
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.titleFont
    }
    
    func configureGradient() {
        recipeImageView.setupGradient(frame: self.bounds,
                                      colors: Constants.Gradient.colors,
                                      locations: Constants.Gradient.locations)
    }
    
    func configureUI() {
        [recipeImageView, titleLabel].forEach { addSubview($0) }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Inset.classic)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.RecipeImage.dividedBy)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Inset.huge)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.tiny)
        }
    }
}

// MARK: - Constants

private extension Constants {
    static let cellReuseIdentifier = "RecommendationCollectionViewCellSK"
    
    struct RecipeImage {
        static let dividedBy = CGFloat(3 / 2)
    }
    
    struct Gradient {
        static let colors = [UIColor.black.withAlphaComponent(0.74).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        static let locations = [NSNumber(0.0), NSNumber(0.5)]
    }
}

private extension UIFont {
    static let titleFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
}
