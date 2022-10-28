import SnapKit
import UIKit

final class DetailsView: BaseView {
    
    // MARK: - Properties
    
    var recipeImagesCollectionView: UICollectionView
    var recommendationImagesCollectionView: UICollectionView
    let pageControl = UIPageControl()
    let recipeNameLabel = UILabel()
    let timestampLabel = UILabel()
    let descriptionTextLabel = UILabel()
    let difficultyTitleLabel = UILabel()
    let difficultyView = DifficultyView()
    let instructionTitleLabel = UILabel()
    let instructionTextLabel = UILabel()
    let recommendedTitleLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // MARK: - For Action
    
    var didPressSortByButton: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        let layoutRecipeImages = UICollectionViewFlowLayout()
        layoutRecipeImages.scrollDirection = .horizontal
        recipeImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutRecipeImages)

        let layoutRecipeRecommendationsImages = UICollectionViewFlowLayout()
        layoutRecipeRecommendationsImages.scrollDirection = .horizontal
        recommendationImagesCollectionView = UICollectionView(frame: CGRect.zero,
                                                              collectionViewLayout: layoutRecipeRecommendationsImages)
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    override func configureAppearance() {
        backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        configureTitleLabels()
        configureTextLabels()
        configureRecipeNameLabel()
        configureTimestampLabel()
        configureRecipeImagesCollection()
        configureRecipeRecommendationsImagesCollection()
    }
    
    override func configureUI() {
        addSubview()
        
        congigureUIMain()
        configureUITop()
        configureUIDifficulty()
        configureUIInstruction()
        configureUIRecommendation()
    }
}

// MARK: - Actions

@objc
private extension DetailsView {
    func sortByButtonPressed() {
        didPressSortByButton?()
    }
}

// MARK: - Private Methods

private extension DetailsView {
    
    func addSubview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [recipeImagesCollectionView,
         pageControl,
         timestampLabel,
         recipeNameLabel,
         descriptionTextLabel,
         difficultyTitleLabel,
         difficultyView,
         instructionTitleLabel,
         instructionTextLabel,
         recommendedTitleLabel,
         recommendationImagesCollectionView].forEach { contentView.addSubview($0) }
    }
    
    func configureTitleLabels() {
        recommendedTitleLabel.font = UIFont.big
        recommendedTitleLabel.textColor = .darkGray
        
        instructionTitleLabel.font = UIFont.big
        instructionTitleLabel.textColor = .darkGray
        
        difficultyTitleLabel.font = UIFont.big
        difficultyTitleLabel.textColor = .darkGray
    }
    
    func configureTextLabels() {
        instructionTextLabel.font = UIFont.thin
        instructionTextLabel.textColor = .gray
        instructionTextLabel.numberOfLines = .zero
        
        descriptionTextLabel.font = UIFont.thin
        descriptionTextLabel.textColor = .gray
        descriptionTextLabel.numberOfLines = .zero
    }
    
    func configureRecipeNameLabel() {
        recipeNameLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        recipeNameLabel.font = UIFont.huge
        recipeNameLabel.textColor = .darkGray
        
    }
    
    func configureTimestampLabel() {
        timestampLabel.font = UIFont.thin
        timestampLabel.textColor = .darkGray
    }
    
    func configureRecipeImagesCollection() {
        recipeImagesCollectionView.showsHorizontalScrollIndicator = false
        recipeImagesCollectionView.isPagingEnabled = true
        recipeImagesCollectionView.backgroundColor = .white
    }
    
    func configureRecipeRecommendationsImagesCollection() {
        recommendationImagesCollectionView.showsHorizontalScrollIndicator = false
        recommendationImagesCollectionView.backgroundColor = .white
        recommendationImagesCollectionView.contentInset.left = Constants.Inset.classic
        recommendationImagesCollectionView.contentInset.right = Constants.Inset.classic
    }
    
    func congigureUIMain() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(self)
        }
    }
    
    func configureUITop() {
        recipeImagesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.RecipeImageCollection.height)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(recipeImagesCollectionView.snp.bottom)
            make.centerX.equalTo(recipeImagesCollectionView.snp.centerX)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recipeNameLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
        
        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImagesCollectionView.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-Constants.Inset.classic)
        }
        
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    func configureUIDifficulty() {
        difficultyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
        
        difficultyView.snp.makeConstraints { make in
            make.top.equalTo(difficultyTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    func configureUIInstruction() {
        instructionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyView.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
        
        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    func configureUIRecommendation() {
        recommendedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
        
        recommendationImagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendedTitleLabel.snp.bottom)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(Constants.RecommendationImageCollection.height)
        }
    }
}

// MARK: - Constants

private extension Constants {
    struct SortByButton {
        static let title = "Sort by"
    }
    struct SearchBar {
        static let placeholder = "Search"
    }
    struct RecommendationImageCollection {
        static let height = CGFloat(190)
    }
    struct RecipeImageCollection {
        static let height = CGFloat(300)
    }
    struct Text {
        static let numberOfLinesStandart = 2
    }
}
