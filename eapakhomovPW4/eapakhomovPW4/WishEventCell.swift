import UIKit

final class WishEventCell: UICollectionViewCell {

    // MARK: - Identifier
    static let reuseIdentifier: String = "WishEventCell"

    // MARK: - UI Elements
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell Configuration
    func configure(with event: WishEvent) {
        titleLabel.text = event.title
        descriptionLabel.text = event.eventDescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if let startDate = event.startDate {
            startDateLabel.text = "Start Date: \(dateFormatter.string(from: startDate))"
        } else {
            startDateLabel.text = "Start Date: N/A"
        }
        if let endDate = event.endDate {
            endDateLabel.text = "End Date: \(dateFormatter.string(from: endDate))"
        } else {
            endDateLabel.text = "End Date: N/A"
        }
    }

    // MARK: - UI Configuration
    private func configureWrap() {
        contentView.addSubview(wrapView)
        wrapView.pin(to: contentView, Constants.offset)
        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.wrapColor
    }

    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleColor
        titleLabel.numberOfLines = 1

        titleLabel.pinTop(to: wrapView.topAnchor, Constants.titleTop)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, Constants.titleLeading)
        titleLabel.pinRight(to: wrapView.trailingAnchor, Constants.titleTrailing)
    }

    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = Constants.descriptionColor
        descriptionLabel.numberOfLines = 0

        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, Constants.descriptionLeading)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, Constants.descriptionTrailing)
    }

    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.font = Constants.dateFont
        startDateLabel.textColor = Constants.dateColor

        startDateLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.dateTop)
        startDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.dateLeading)
        startDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.dateTrailing)
    }

    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.font = Constants.dateFont
        endDateLabel.textColor = Constants.dateColor

        endDateLabel.pinTop(to: startDateLabel.bottomAnchor, Constants.dateTop)
        endDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.dateLeading)
        endDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.dateTrailing)
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, Constants.dateBottom)
    }
}
