import SnapKit
import UIKit

class ErrorPageView: UIView {
    
    /// for action
    var didPressButton: (() -> Void)?
    
    // MARK: - Properties
    
    private let errorBox = UIStackView()
    private let titleTextLabel = UILabel()
    private let descriptionTextLabel = UILabel()
    private let mainButton = UIButton(type: .system)
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        configureAppearance()
        mainButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ErrorPageView {
    func setData(with title: String, message: String, buttonText: String) {
        titleTextLabel.text = title
        descriptionTextLabel.text = message
        mainButton.setTitle(buttonText, for: .normal)
    }
}

// MARK: - Actions

@objc
private extension ErrorPageView {
    func buttonPressed() {
        didPressButton?()
    }
}

// MARK: - Private Methods

private extension ErrorPageView {
    
    func configureAppearance() {
        isHidden = true
        backgroundColor = .white
        
        configureErrorBox()
        configureTitleLabel()
        configureDescriptionLabel()
        configureRefreshButton()
        configureUI()
    }
    
    func configureErrorBox() {
        errorBox.alignment = .center
        errorBox.axis = .vertical
        errorBox.spacing = Constants.Design.spacingMain
    }
    
    func configureTitleLabel() {
        titleTextLabel.font = UIFont.big
        titleTextLabel.numberOfLines = .zero
    }
    
    func configureDescriptionLabel() {
        descriptionTextLabel.numberOfLines = .zero
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.font = UIFont.standart
    }
    
    func configureRefreshButton() {
        mainButton.backgroundColor = .none
        mainButton.titleLabel?.font = UIFont.standart
        mainButton.setTitleColor(.systemBlue, for: .normal)
        mainButton.setTitleColor(.black, for: .selected)
        mainButton.layer.cornerRadius = Constants.Design.cornerRadiusError
        mainButton.layer.borderWidth = Constants.Design.borderWidth
        mainButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func configureUI() {
        addSubview(errorBox)
        errorBox.snp.makeConstraints { make in
            make.leading.equalTo(Constants.Design.basicInset)
            make.trailing.equalTo(-Constants.Design.basicInset)
            make.top.greaterThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.centerY.equalToSuperview()
        }
        
        [titleTextLabel, descriptionTextLabel, mainButton].forEach { errorBox.addArrangedSubview($0) }
        mainButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Button.height)
            make.width.equalTo(errorBox.snp.width).dividedBy(Constants.Button.divison)
        }
    }
}

// MARK: - Constants

private extension Constants {
    struct Button {
        static let height = CGFloat(45)
        static let divison = CGFloat(1.15)
    }
}
