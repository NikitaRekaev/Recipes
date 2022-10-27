import SnapKit
import UIKit

final class DifficultyView: UIView {
    
    // MARK: - UI Elements
    
    private let difficultyImagesCollection = UIStackView()
    
    // MARK: - Properties
    
    var difficulty: Int = .zero {
        didSet {
            difficultyImagesCollection.arrangedSubviews.forEach { view in
                difficultyImagesCollection.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            for _ in .zero..<difficulty {
                let image = R.image.shapeTrue()
                let imageView = UIImageView(image: image)
                difficultyImagesCollection.addArrangedSubview(imageView)
            }
            
            for _ in difficulty..<Constants.maxDifficultyStarAmount {
                let image = R.image.shapeFalse()
                let imageView = UIImageView(image: image)
                difficultyImagesCollection.addArrangedSubview(imageView)
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension DifficultyView {
    
    func configureAppearance() {
        configureDifficultyImagesCollection()
        configureUI()
    }
    
    func configureDifficultyImagesCollection() {
        difficultyImagesCollection.axis = .horizontal
        difficultyImagesCollection.distribution = .fillEqually
        difficultyImagesCollection.alignment = .leading
        difficultyImagesCollection.spacing = Constants.DifficultyImageCollection.spacing
    }
    
    func configureUI() {
        addSubview(difficultyImagesCollection)
        difficultyImagesCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Constants

private extension Constants {
    
    static let maxDifficultyStarAmount = 5
    
    struct DifficultyImageCollection {
        static let spacing = CGFloat(20)
    }
}
