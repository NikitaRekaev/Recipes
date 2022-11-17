import UIKit

class ListViewController: BaseViewController<ListView> {
    
    // MARK: - Properties
    
    let viewModel: ListViewModel
    let alertView = ErrorPageView()
    
    private var filteredRecipes: [TableCellViewModel] = []
    private var currentSearchCase = SearchCase.all
    
    private var currentSortCase = SortCase.date {
        didSet {
            filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
            selfView.tableView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = Constants.BackButton.text
        
        setNavigationItem()
        setTableView()
        setSearchController()
        
        bindToViewModel()
        viewModel.reloadData()
        
        setCustomAlert(alertView)
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRecipes.count
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        filteredRecipes[indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filteredRecipes[indexPath.row].cellSelected()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Cell.height
    }
    
}

// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterAndSort()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBar()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        hideSearchBar(withPlaceholder: searchBar.text)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
        hideSearchBar(withPlaceholder: searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar(withPlaceholder: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterAndSort()
    }
    
    // MARK: - SearchBar Helpers
    
    private func hideSearchBar(withPlaceholder placeholder: String?) {
        selfView.searchController.searchBar.placeholder = placeholder
        selfView.searchController.searchBar.showsScopeBar = false
        selfView.searchController.searchBar.setShowsCancelButton(false, animated: true)
        selfView.searchController.searchBar.endEditing(true)
        selfView.searchController.isActive = false
    }
    
    private func showSearchBar() {
        selfView.searchController.searchBar.showsScopeBar = true
        selfView.searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    private func resetSearchBar() {
        selfView.searchController.searchBar.text = ""
        filteredRecipes = viewModel.viewModels
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        selfView.tableView.reloadData()
    }
    
    private func filterAndSort() {
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: selfView.searchController.searchBar.text,
                                                               scope: currentSearchCase)
        
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        
        selfView.tableView.reloadData()
    }
}

// MARK: - CustomAlertDisplaying

extension ListViewController: CustomAlertDisplaying {
    
    func handleButtonTap() {
        viewModel.reloadData()
    }
}

// MARK: - Actions

@objc
private extension ListViewController {
    
    func sortByButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByName, style: .default) { _ in
            self.currentSortCase = .name
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByDate, style: .default) { _ in
            self.currentSortCase = .date
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.cancel, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Private Methods

private extension ListViewController {
    
    func setSearchController() {
        selfView.searchController.searchBar.delegate = self
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.SortByButton.title,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(sortByButtonTapped))
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = selfView.searchController
    }
    
    func setTableView() {
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
        TableCellViewModel.registerCell(tableView: selfView.tableView)
    }
    
    func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.didFinishUpdating()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError(error)
        }
    }
    
    func didFinishSuccessfully() {
        hideCustomAlert(alertView)
    }
    
    /// In case update was triggered by refreshing the table
    func didFinishUpdating() {
        filteredRecipes = viewModel.filterRecipesForSearchText(
            searchText: selfView.searchController.searchBar.text,
            scope: currentSearchCase)
        
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        selfView.tableView.reloadData()
        hideCustomAlert(alertView)
    }
    
    func didReceiveError(_ error: Error) {
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
        } else {
            title = Constants.ErrorType.basic
        }
        
        showCustomAlert(alertView,
                        title: title,
                        message: error.localizedDescription,
                        buttonText: Constants.ButtonTitle.refresh)
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
    
    struct BackButton {
        static let text = "Back"
    }
    
    struct ActionSheet {
        static let sortByName = "Sort by Name"
        static let sortByDate = "Sort by Date"
        static let cancel = "Cancel"
    }
    
    struct Cell {
        static let height = CGFloat(180)
    }
}
