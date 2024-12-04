import UIKit

final class AddWishCell: UITableViewCell, UITextViewDelegate {
    // MARK: - Fields
    static let reuseId: String = "AddWishCell"
    private let wishTextView: UITextView = UITextView()
    private let addWishButton: UIButton = UIButton(type: .system)
    private let wrap: UIView = UIView()
    private var wrapHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Properties
    var addWish: ((String) -> Void)?
    
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholderText
            textView.textColor = .lightGray
        }
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wrap)
        wrap.addSubview(wishTextView)
        wrap.addSubview(addWishButton)
        
        configureWrap()
        configureTextView()
        configureButton()
    }
    
    private func configureWrap() {
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinVertical(to: contentView, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: contentView, Constants.wrapOffsetH)
    }
    
    private func configureTextView() {
        wishTextView.text = Constants.placeholderText
        wishTextView.font = UIFont.systemFont(ofSize: Constants.wishTextViewFontSize)
        wishTextView.textColor = .lightGray
        wishTextView.isScrollEnabled = true
        wishTextView.textContainer.maximumNumberOfLines = .zero
        wishTextView.textContainer.lineBreakMode = .byWordWrapping
        wishTextView.pinVertical(to: wrap, Constants.wishLabelOffset)
        wishTextView.pinLeft(to: wrap, Constants.wishLabelOffset)
        wishTextView.pinRight(to: addWishButton.leadingAnchor, Constants.wishLabelOffset)
        wishTextView.delegate = self
    }
    
    private func configureButton() {
        addWishButton.setTitle(Constants.addWishButtonTitle, for: .normal)
        addWishButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        addWishButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.addWishButtonFontSize)
        addWishButton.backgroundColor = Constants.buttonBackgroundGreenColor
        addWishButton.layer.cornerRadius = Constants.stackRadius
        
        addWishButton.pinVertical(to: wrap)
        addWishButton.pinRight(to: wrap)
        addWishButton.setWidth(Constants.addWishButtonWidth)
        
        addWishButton.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addWishButtonTapped() {
        guard let wishText = wishTextView.text, !wishText.isEmpty, wishText != Constants.placeholderText || wishTextView.textColor != .lightGray else {
            return
        }
        addWish?(
            wishText
        )
        wishTextView.text = Constants.placeholderText
        wishTextView.textColor = .lightGray
    }
}
