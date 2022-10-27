import UIKit

final class ListCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let rootNavigationController: UINavigationController
    let repository: Repository
    
    weak var delegate: AppCoordinator?
    
    // MARK: - Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
    }
    
    override func start() {
        
        let listViewModel = ListViewModel(repository: repository)
        
        let listViewController = ListViewController(viewModel: listViewModel)
        listViewController.title = Constants.NavigationBarTitle.recipes
        
        rootNavigationController.setViewControllers([listViewController], animated: false)
    }
    
}
