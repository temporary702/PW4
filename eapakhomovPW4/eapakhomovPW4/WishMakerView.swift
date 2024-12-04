import UIKit

final class WishMakerView: UIView {

    // MARK: - UI Elements
    private let titleView = UILabel()
    private let descr = UILabel()
    let stack = UIStackView()
    private let toggleButton: UIButton = UIButton(type: .system)
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishButton: UIButton = UIButton(type: .system)
    private let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
    private let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
    private let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)

    private var toggleButtonBottomConstraint: NSLayoutConstraint?

    // MARK: - Callbacks
    var onColorChange: ((UIColor) -> Void)?
    var onToggleButtonPressed: (() -> Void)?
    var onWishButtonPressed: (() -> Void)?
    var onScheduleWishButtonPressed: (() -> Void)?

    // MARK: - Properties
    var redSliderValue: Float { sliderRed.slider.value }
    var greenSliderValue: Float { sliderGreen.slider.value }
    var blueSliderValue: Float { sliderBlue.slider.value }
    var alphaSliperValue = Constants.alphaValue

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
    func updateTextColor(to color: UIColor) {
        titleView.textColor = color
        descr.textColor = color
    }

    func updateBackgroundColor(to color: UIColor) {
        backgroundColor = color
    }

    func setStackVisibility(isHidden: Bool) {
        stack.isHidden = isHidden
    }

    func updateButtonTitle(isHidden: Bool) {
        toggleButton.setTitle(isHidden ? Constants.buttonTitleShow : Constants.buttonTitleHide, for: .normal)
    }

    // MARK: - Private Methods
    private func configureUI() {
        backgroundColor = UIColor(
            red: Constants.colorValue,
            green: Constants.colorValue,
            blue: Constants.colorValue,
            alpha: Constants.alphaValue
        )
        configureTitle()
        configureDescription()
        configureStack()
        configureToggleButton()
    }

    private func configureTitle() {
        titleView.text = Constants.titleText
        titleView.font = UIFont.boldSystemFont(ofSize: Constants.titleSize)

        addSubview(titleView)
        titleView.pinTop(to: safeAreaLayoutGuide.topAnchor, Constants.titleTopPadding)
        titleView.pinCenterX(to: self)
    }

    private func configureDescription() {
        descr.text = Constants.descriptionText
        descr.font = UIFont.systemFont(ofSize: Constants.descriptionSize)
        descr.numberOfLines = .zero
        descr.lineBreakMode = .byWordWrapping

        addSubview(descr)
        descr.pinLeft(to: self, Constants.descriptionPadding)
        descr.pinRight(to: self, Constants.descriptionPadding)
        descr.pinTop(to: titleView.bottomAnchor, Constants.descriptionPadding)
    }

    private func configureStack() {
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.layer.cornerRadius = Constants.stackRadius
        stack.layer.borderWidth = Constants.borderWidth
        stack.clipsToBounds = true

        addSubview(stack)

        for slider in [sliderRed, sliderGreen, sliderBlue] {
            stack.addArrangedSubview(slider)
            slider.valueChanged = { [weak self] _ in self?.notifyColorChange() }
        }

        stack.addArrangedSubview(addWishButton)
        stack.addArrangedSubview(scheduleWishButton)

        configureAddWishButton()
        configureScheduleWishButton()

        stack.pinCenterX(to: self)
        stack.pinLeft(to: self.leadingAnchor, Constants.stackLeading)
        stack.pinBottom(to: safeAreaLayoutGuide.bottomAnchor, Constants.buttonBottom)
    }

    private func configureAddWishButton() {
        addWishButton.backgroundColor = Constants.buttonBackgroundColor
        addWishButton.setTitleColor(Constants.wishButtonTitleColor, for: .normal)
        addWishButton.setTitle(Constants.wishButtonText, for: .normal)
        addWishButton.layer.cornerRadius = Constants.stackRadius
        addWishButton.layer.borderWidth = Constants.borderWidth
        addWishButton.addTarget(self, action: #selector(wishButtonPressed), for: .touchUpInside)
        addWishButton.setHeight(Constants.buttonHeight)
    }

    private func configureScheduleWishButton() {
        scheduleWishButton.backgroundColor = Constants.buttonBackgroundColor
        scheduleWishButton.setTitleColor(Constants.wishButtonTitleColor, for: .normal)
        scheduleWishButton.setTitle(Constants.scheduleWishButtonText, for: .normal)
        scheduleWishButton.layer.cornerRadius = Constants.stackRadius
        scheduleWishButton.layer.borderWidth = Constants.borderWidth
        scheduleWishButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)
        scheduleWishButton.setHeight(Constants.buttonHeight)
    }

    private func configureToggleButton() {
        toggleButton.setTitle(Constants.buttonTitleHide, for: .normal)
        toggleButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        toggleButton.backgroundColor = Constants.buttonBackgroundColor
        toggleButton.layer.cornerRadius = Constants.stackRadius
        toggleButton.layer.borderWidth = Constants.borderWidth
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)

        addSubview(toggleButton)
        toggleButton.setHeight(Constants.buttonHeight)
        toggleButton.pinCenterX(to: centerXAnchor)
        toggleButton.pinLeft(to: stack.leadingAnchor)
        toggleButtonBottomConstraint = toggleButton.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -Constants.buttonBottom)
        toggleButtonBottomConstraint?.isActive = true
    }

    private func notifyColorChange() {
        onColorChange?(UIColor(
            red: CGFloat(redSliderValue),
            green: CGFloat(greenSliderValue),
            blue: CGFloat(blueSliderValue),
            alpha: Constants.alphaValue
        ))
    }

    @objc private func toggleButtonPressed() {
        stack.isHidden.toggle()
        updateButtonTitle(isHidden: stack.isHidden)
    }

    @objc private func wishButtonPressed() {
        onWishButtonPressed?()
    }

    @objc private func scheduleWishButtonPressed() {
        onScheduleWishButtonPressed?()
    }
}
