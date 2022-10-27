import SnapKit
import UIKit

final class ListView: BaseView {
    
    // MARK: - UI Elements
    
    let tableView = UITableView()
    let searchController = UISearchController()
    
    // MARK: - Configure
    
    override func configureAppearance() {
        backgroundColor = .white
    }
    
    override func configureUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Private Methods

private extension ListView {
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
}
