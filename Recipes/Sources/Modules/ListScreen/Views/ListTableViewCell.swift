import Kingfisher
import SnapKit
import UIKit

class ListTableViewCell: UITableViewCell {
    
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
    
    private let recipeImageView = UIImageView()
    private let labelsContainer = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timestampLabel = UILabel()
    
    private var recipe: DataForCell! {
        didSet {
            titleLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            timestampLabel.text = recipe.lastUpdated
            
            /// set first image of recipe
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: recipe.imageLink), placeholder: UIImage(named: "Placeholder"))
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
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
    
    func configureAppearance() {
        configureRecipeImage()
        configureTitleLabel()
        configureDescriptionLabel()
        configureTimestampLabel()
        configureLabelsContainer()
        configureUI()
    }
    
    func configureRecipeImage() {
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = 15
        recipeImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
    }
    
    func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        titleLabel.textColor = .darkGray
        titleLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        descriptionLabel.textColor = .systemGray
        descriptionLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureTimestampLabel() {
        timestampLabel.font = UIFont.systemFont(ofSize: 18)
        timestampLabel.textColor = .darkGray
        timestampLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureLabelsContainer() {
        labelsContainer.alignment = .leading
        labelsContainer.axis = .vertical
        labelsContainer.spacing = Constants.LabelsContainer.spacing
    }
    
    func configureUI() {
        [recipeImageView, labelsContainer, timestampLabel].forEach { addSubview($0) }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.Image.widthDivision)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(18)
            make.trailing.lessThanOrEqualTo(recipeImageView.snp.leading).offset(-20)
        }
        
        labelsContainer.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.top)
            make.bottom.lessThanOrEqualTo(timestampLabel.snp.top).inset(-Constants.LabelsContainer.spacing)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(recipeImageView.snp.leading).offset(-20)
        }

        labelsContainer.addArrangedSubview(titleLabel)
        labelsContainer.addArrangedSubview(descriptionLabel)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cellReuseIdentifier = "RecipeTableViewCell"
    
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