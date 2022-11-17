import SnapKit
import UIKit

final class ListView: BaseView {
    
    // MARK: - UI Elements
    
    let tableView = UITableView()
    let searchController = UISearchController()
    
    // MARK: - Configure
    
    override func setViewAppearance() {
        backgroundColor = .white
        setTableView()
    }
    
    override func setViewPosition() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Private Methods

private extension ListView {
    
    private func setTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
}
