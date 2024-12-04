import UIKit
import CoreData
import EventKit

protocol WishEventCreationDelegate: AnyObject {
    func didCreateWishEvent()
}

final class WishEventCreationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    private let descriptionLabel = UILabel()
    private let descriptionTextField = UITextField()
    private let startDateLabel = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDateLabel = UILabel()
    private let endDatePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    weak var delegate: WishEventCreationDelegate?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        configureLabels()
        configureTextFields()
        configureDatePickers()
        configureButtons()
        configureLayout()
    }
    
    private func configureLabels() {
        titleLabel.text = "Title"
        descriptionLabel.text = "Description"
        startDateLabel.text = "Start Date"
        endDateLabel.text = "End Date"
    }
    
    private func configureTextFields() {
        titleTextField.borderStyle = .roundedRect
        descriptionTextField.borderStyle = .roundedRect
    }
    
    private func configureDatePickers() {
        startDatePicker.datePickerMode = .dateAndTime
        endDatePicker.datePickerMode = .dateAndTime
    }
    
    private func configureButtons() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, titleTextField,
            descriptionLabel, descriptionTextField,
            startDateLabel, startDatePicker,
            endDateLabel, endDatePicker,
            saveButton, cancelButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        saveButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func saveButtonTapped() {
        guard let titleText = titleTextField.text, !titleText.isEmpty,
              let descriptionText = descriptionTextField.text, !descriptionText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if endDatePicker.date < startDatePicker.date {
            let alert = UIAlertController(title: "Error", message: "End date must be after start date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let newEvent = WishEvent(context: context)
        newEvent.title = titleText
        newEvent.eventDescription = descriptionText
        newEvent.startDate = startDatePicker.date
        newEvent.endDate = endDatePicker.date
        
        do {
            try context.save()
            delegate?.didCreateWishEvent()
        } catch {
            print("Failed to save WishEvent: \(error)")
        }

        let calendarManager = CalendarManager()
        let calendarEventModel = CalendarEventModel(
            title: titleText,
            startDate: startDatePicker.date,
            endDate: endDatePicker.date,
            note: descriptionText
        )
        
        calendarManager.create(eventModel: calendarEventModel) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
