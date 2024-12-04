import UIKit
import CoreData

final class WishCalendarViewController: UIViewController {

    // MARK: - Properties
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private var wishEvents: [WishEvent] = []

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureUI()
        fetchWishEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWishEvents()
    }

    // MARK: - Private Methods
    private func configureUI() {
        title = "Wish Calendar"
        configureNavigationBar()
        configureCollection()
    }

    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonTapped() {
        let eventCreationVC = WishEventCreationViewController()
        eventCreationVC.delegate = self
        present(eventCreationVC, animated: true, completion: nil)
    }

    private func configureCollection() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset

        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )

        view.addSubview(collectionView)

        collectionView.pinHorizontal(to: view)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.collectionTop)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }

    private func fetchWishEvents() {
        let fetchRequest: NSFetchRequest<WishEvent> = WishEvent.fetchRequest()
        do {
            wishEvents = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch WishEvents: \(error)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return wishEvents.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WishEventCell.reuseIdentifier,
            for: indexPath
        )

        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }

        let event = wishEvents[indexPath.item]
        wishEventCell.configure(with: event)

        return wishEventCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 150)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}

// MARK: - WishEventCreationDelegate
extension WishCalendarViewController: WishEventCreationDelegate {
    func didCreateWishEvent() {
        fetchWishEvents()
    }
}
