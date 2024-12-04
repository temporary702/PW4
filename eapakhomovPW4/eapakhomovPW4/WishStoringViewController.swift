import UIKit

final class WishStoringViewController: UIViewController {
    // MARK: - Fields
    private var wishArray: [String] = []
    private let userDefaultsHelper: UserDefaultsHelper = UserDefaultsHelper()
    private let wishStoringView = WishStoringView()
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        self.view = wishStoringView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.blueBackgroundColor
        
        wishArray = userDefaultsHelper.loadWishes()
        wishStoringView.setTableDataSource(self)
    }
    
    // MARK: - Private Methods
    private func handleEditWish(at index: Int) {
        let currentWish = wishArray[index]
        
        let alertController = UIAlertController(title: Constants.alertEditTitle, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = currentWish
        }
        
        let saveAction = UIAlertAction(title: Constants.alertSaveTitle, style: .default) { [weak self] _ in
            guard let updatedWish = alertController.textFields?.first?.text, !updatedWish.isEmpty else { return }
            self?.wishArray[index] = updatedWish
            self?.userDefaultsHelper.saveWishes(self?.wishArray ?? [])
            self?.wishStoringView.table.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: Constants.alertCancelTitle, style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath)
            
            guard let addWishCell = cell as? AddWishCell else { return cell }
            
            addWishCell.addWish = { [weak self] wishText in
                self?.wishArray.append(wishText)
                tableView.reloadData()
                self?.userDefaultsHelper.saveWishes(self?.wishArray ?? [])
            }
            return addWishCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
            
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.configure(with: wishArray[indexPath.row])
            
            wishCell.deleteWish = { [weak self] in
                guard let self = self else { return }
                self.wishArray.remove(at: indexPath.row)
                tableView.reloadData()
                self.userDefaultsHelper.saveWishes(self.wishArray)
            }
            
            wishCell.editWish = { [weak self] in
                self?.handleEditWish(at: indexPath.row)
            }
            
            return wishCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
}
