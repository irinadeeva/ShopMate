import UIKit

protocol FilterDelegate: AnyObject {
  func didApplyFilters(priceMax: Int?, categoryId: Int?)
}

final class FilterBottomSheetViewController: UIViewController {
  weak var delegate: FilterDelegate?
  
  private let priceRangeLabel = UILabel()
  private let priceSlider = UISlider()
  private let categoryPicker = UIPickerView()
  private let applyButton = UIButton()
  
  var categories: [Category] = []
  private var selectedCategoryIndex: Int?
  private var minPrice: Double = 0
  private var maxPrice: Double = 100
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .background
    view.layer.cornerRadius = 16
    
    priceRangeLabel.text = "Price: $\(Int(minPrice))"
    priceRangeLabel.textAlignment = .center
    
    priceSlider.minimumValue = Float(minPrice)
    priceSlider.maximumValue = Float(maxPrice)
    priceSlider.value = Float(minPrice)
    priceSlider.addTarget(self, action: #selector(priceChanged), for: .valueChanged)
    
    categoryPicker.delegate = self
    categoryPicker.dataSource = self
    
    applyButton.setTitle("Apply Filters", for: .normal)
    applyButton.backgroundColor = .systemBlue
    applyButton.layer.cornerRadius = 8
    applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
    
    let stackView = UIStackView(arrangedSubviews: [priceRangeLabel, priceSlider, categoryPicker, applyButton])
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
  
  @objc private func priceChanged() {
    priceRangeLabel.text = "Price: $\(Int(priceSlider.value))"
  }
  
  @objc private func applyFilters() {
    var priceMax: Int? = Int(priceSlider.value)
    if priceMax == 0 {
      priceMax = nil
    }

    var categoryId = selectedCategoryIndex
    if let selectedCategoryIndex = selectedCategoryIndex {
      categoryId = categories[selectedCategoryIndex].id
    }

    delegate?.didApplyFilters(priceMax: priceMax, categoryId: categoryId)
    dismiss(animated: true)
  }
}

extension FilterBottomSheetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categories[row].name
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedCategoryIndex = row
  }
}
