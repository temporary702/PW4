import UIKit

final class WrittenWishCell: UITableViewCell {
    // MARK: - Fields
    static let reuseId: String = "WrittenWishCell"
    private let wishLabel: UILabel = UILabel()
    private let deleteWishButton: UIButton = UIButton(type: .system)
    private let editWishButton: UIButton = UIButton(type: .system)
    private let wrap: UIView = UIView()
    
    // MARK: - Properties
    var deleteWish: (() -> Void)?
    var editWish: (() -> Void)?
    
    // MARK: - Lifecycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wrap)
        wrap.addSubview(wishLabel)
        wrap.addSubview(deleteWishButton)
        wrap.addSubview(editWishButton)
        
        configureWrap()
        configureButton()
        configureEditButton()
        configureLabel()
    }
    
    private func configureWrap() {
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinVertical(to: contentView, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: contentView, Constants.wrapOffsetH)
    }
    
    private func configureButton() {
        deleteWishButton.setTitle(Constants.deleteButtonTitle, for: .normal)
        deleteWishButton.setTitleColor(Constants.deleteButtonTitleColor, for: .normal)
        deleteWishButton.backgroundColor = Constants.deleteButtonBackgroundColor
        deleteWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        deleteWishButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize)
        
        deleteWishButton.pinVertical(to: wrap)
        deleteWishButton.pinRight(to: wrap)
        deleteWishButton.setWidth(Constants.buttonWidth)
        
        deleteWishButton.addTarget(self, action: #selector(deleteWishButtonTapped), for: .touchUpInside)
    }
    
    private func configureEditButton() {
        editWishButton.setTitle(Constants.editButtonTitle, for: .normal)
        editWishButton.setTitleColor(Constants.editButtonTitleColor, for: .normal)
        editWishButton.backgroundColor = Constants.editButtonBackgroundColor
        editWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        editWishButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize)
        
        editWishButton.pinVertical(to: wrap)
        editWishButton.pinRight(to: deleteWishButton.leadingAnchor, Constants.wishLabelOffset)
        editWishButton.setWidth(Constants.buttonWidth)
        
        editWishButton.addTarget(self, action: #selector(editWishButtonTapped), for: .touchUpInside)
    }
    
    private func configureLabel() {
        wishLabel.pinVertical(to: wrap, Constants.wishLabelOffset)
        wishLabel.pinLeft(to: wrap.leadingAnchor, Constants.wishLabelOffset)
        wishLabel.pinRight(to: editWishButton.leadingAnchor, Constants.wishLabelOffset)
        wishLabel.font = .systemFont(ofSize: Constants.labelFontSize)
        wishLabel.numberOfLines = .zero
        wishLabel.lineBreakMode = .byWordWrapping
    }
    
    @objc private func deleteWishButtonTapped() {
        deleteWish?()
    }
    
    @objc private func editWishButtonTapped() {
        editWish?()
    }
}
