import Kingfisher
import SnapKit
import UIKit

final class ListTableViewCell: UITableViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> ListTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier,
                                                       for: indexPath) as? ListTableViewCell
        else {
            return ListTableViewCell()
        }
        return cell
    }
    
    // MARK: - Properties
    
    private var viewModel: TableCellViewModel!
    
    var didPressButton: (() -> Void)?
    
    private let recipeImageView = ListTableViewCell.makeRecipeImage()
    private let labelsContainer = ListTableViewCell.makeLabelsContainer()
    private let titleLabel = ListTableViewCell.makeTitleLabel()
    private let descriptionLabel = ListTableViewCell.makeDescriptionLabel()
    private let timestampLabel = ListTableViewCell.makeTimestampLabel()
    
    private var recipe: DataForCell! {
        didSet {
            titleLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            timestampLabel.text = recipe.lastUpdated
            
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: recipe.imageLink), placeholder: R.image.placeholder())
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ListTableViewCell {
    
    func setupCellData(viewModel: TableCellViewModel) {
        self.viewModel = viewModel
        self.recipe = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
}

// MARK: - Actions

@objc
private extension ListTableViewCell {
    
    func buttonPressed() {
        didPressButton?()
    }
}

// MARK: - Private Methods

private extension ListTableViewCell {
    
    func setViewPosition() {
        [recipeImageView, labelsContainer, timestampLabel].forEach { addSubview($0) }
        [titleLabel, descriptionLabel].forEach { labelsContainer.addArrangedSubview($0) }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.Image.widthDivision)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(Constants.Inset.small)
            make.trailing.lessThanOrEqualTo(recipeImageView.snp.leading).offset(-Constants.Inset.classic)
        }
        
        labelsContainer.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.top)
            make.bottom.lessThanOrEqualTo(timestampLabel.snp.top).inset(-Constants.LabelsContainer.spacing)
            make.leading.equalToSuperview().inset(Constants.Inset.small)
            make.trailing.equalTo(recipeImageView.snp.leading).offset(-Constants.Inset.classic)
        }
    }
}

// MARK: - Creating SubViews

private extension ListTableViewCell {
    
    static func makeRecipeImage() -> UIImageView {
        let recipeImageView = UIImageView()
        
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return recipeImageView
    }
    
    static func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.enormous
        titleLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        titleLabel.textColor = .darkGray
        titleLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
        
        return titleLabel
    }
    
    static func makeDescriptionLabel() -> UILabel {
        let descriptionLabel = UILabel()
        
        descriptionLabel.font = UIFont.standart
        descriptionLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        descriptionLabel.textColor = .systemGray
        descriptionLabel.minimumScaleFactor = Constants.Text.minimumScale
        
        return descriptionLabel
    }
    
    static func makeTimestampLabel() -> UILabel {
        let timestampLabel = UILabel()
        
        timestampLabel.font = UIFont.standart
        timestampLabel.textColor = .darkGray
        timestampLabel.minimumScaleFactor = Constants.Text.minimumScale
        
        return timestampLabel
    }
    
    static func makeLabelsContainer() -> UIStackView {
        let labelsContainer = UIStackView()
        
        labelsContainer.alignment = .leading
        labelsContainer.axis = .vertical
        labelsContainer.spacing = Constants.LabelsContainer.spacing
        
        return labelsContainer
    }
}

// MARK: - Constants

private extension Constants {
    
    static let cellReuseIdentifier = "ListTableViewCell"
    
    struct Image {
        static let widthDivision = CGFloat(2.3)
    }
    
    struct Text {
        static let minimumScale = CGFloat(0.85)
        static let numberOfLinesStandart = 2
    }
    
    struct LabelsContainer {
        static let spacing = CGFloat(7)
    }
}
