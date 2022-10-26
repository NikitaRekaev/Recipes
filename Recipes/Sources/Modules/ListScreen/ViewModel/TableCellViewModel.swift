import UIKit

final class TableCellViewModel {
    
    // MARK: - Properties
    
    let data: DataForCell
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didUpdate: ((TableCellViewModel) -> Void)?
    var didSelectRecipe: ((String) -> Void)?
    
    // MARK: - Initialization
    
    init(recipe: DataForCell) {
        self.data = recipe
    }
    
}
