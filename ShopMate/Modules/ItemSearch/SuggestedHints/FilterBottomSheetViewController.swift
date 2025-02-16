import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(title: String?, price: Double?, priceMin: Double?, priceMax: Double?, categoryId: Int?)
}

class FilterBottomSheetViewController: UIViewController {
    weak var delegate: FilterDelegate?

    private let titleTextField = UITextField()
    private let priceTextField = UITextField()
    private let priceMinTextField = UITextField()
    private let priceMaxTextField = UITextField()
    private let categoryTextField = UITextField()
    private let applyButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16

        titleTextField.placeholder = "Title"
        priceTextField.placeholder = "Price"
        priceMinTextField.placeholder = "Min Price"
        priceMaxTextField.placeholder = "Max Price"
        categoryTextField.placeholder = "Category ID"

        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.backgroundColor = .systemBlue
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleTextField, priceTextField, priceMinTextField, priceMaxTextField, categoryTextField, applyButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func applyFilters() {
        let title = titleTextField.text?.isEmpty == true ? nil : titleTextField.text
        let price = Double(priceTextField.text ?? "")
        let priceMin = Double(priceMinTextField.text ?? "")
        let priceMax = Double(priceMaxTextField.text ?? "")
        let categoryId = Int(categoryTextField.text ?? "")

        delegate?.didApplyFilters(title: title, price: price, priceMin: priceMin, priceMax: priceMax, categoryId: categoryId)
        dismiss(animated: true)
    }
}
