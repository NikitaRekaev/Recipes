import UIKit

final class RecommendedImageCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let imageLink: String
    let name: String
    private let uuid: String
    
    // MARK: - Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((RecommendedImageCollectionViewCellViewModel) -> Void)?
    var didSelectRecommendedRecipe: ((String) -> Void)?
    
    // MARK: - Lifecycle
    
    init(name: String, imageLink: String, uuid: String) {
        self.name = name
        self.imageLink = imageLink
        self.uuid = uuid
    }
    
}
