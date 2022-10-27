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
        listViewModel.coordinatorDelegate = self
        
        let listViewController = ListViewController(viewModel: listViewModel)
        listViewController.title = Constants.NavigationBarTitle.recipes
        
        rootNavigationController.setViewControllers([listViewController], animated: false)
    }
    
}

// MARK: - ViewModel Delegate

extension ListCoordinator: ListViewModelCoordinatorDelegate {
    
    /// switches Scene to Recipe Details
    func didSelectRecipe(recipeID: String) {
        let detailsCoordinator = DetailsCoordinator(rootNavigationController: rootNavigationController,
                                                    repository: repository,
                                                    recipeID: recipeID)
        
        detailsCoordinator.delegate = self
        addChildCoordinator(detailsCoordinator)
        rootNavigationController.navigationBar.prefersLargeTitles = false
        detailsCoordinator.start()
    }
    
}

// MARK: - Coordinator Delegate

extension ListCoordinator: DetailsDelegate {
    func didFinish(from coordinator: DetailsCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
