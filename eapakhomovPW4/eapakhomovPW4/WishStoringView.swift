import UIKit

final class WishStoringView: UIView {
    // MARK: - Constants
    let table: UITableView = UITableView(frame: .zero)
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTableDataSource(_ dataSource: UITableViewDataSource) {
        table.dataSource = dataSource
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        configureTable()
    }
    
    private func configureTable() {
        addSubview(table)
        table.backgroundColor = Constants.tableBackgroundColor
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        
        table.pin(to: self, Constants.tableOffset)
    }
}
