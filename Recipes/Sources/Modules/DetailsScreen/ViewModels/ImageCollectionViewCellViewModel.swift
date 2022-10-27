import UIKit

final class ImageCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let data: String
    
    // MARK: - Init
    
    init(imageLink: String) {
        self.data = imageLink
    }
    
    // MARK: - Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((ImageCollectionViewCellViewModel) -> Void)?
    var didSelectImage: ((String) -> Void)?
    
}
