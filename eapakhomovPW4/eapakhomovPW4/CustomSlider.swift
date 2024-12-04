import Foundation
import UIKit

final class CustomSlider: UIView {

    // MARK: - Constants
    enum Constants {
        static let titleTop: Double = 10
        static let titleLeft: Double = 20
        static let sliderBottom: Double = 10
        static let sliderLeft: Double = 20
        static let sliderValue : Float = 0.25
    }
    
    // MARK: - Properties
    var valueChanged: ((Double) -> Void)?
    var slider = UISlider()
    var titleView = UILabel()
    
    // MARK: - Initializer
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.value = Constants.sliderValue
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        backgroundColor = .white
        addSubview(slider)
        addSubview(titleView)

        titleView.pinCenterX(to: centerXAnchor)
        titleView.pinTop(to: topAnchor, Constants.titleTop)
        titleView.pinLeft(to: leadingAnchor, Constants.titleLeft)

        slider.pinCenterX(to: centerXAnchor)
        slider.pinTop(to: titleView.bottomAnchor)
        slider.pinBottom(to: bottomAnchor, Constants.sliderBottom)
        slider.pinLeft(to: leadingAnchor, Constants.sliderLeft)
    }
    
    @objc private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
