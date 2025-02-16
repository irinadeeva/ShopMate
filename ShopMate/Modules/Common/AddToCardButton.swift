import UIKit

final class QuantitySelectorView: UIView {
  var onQuantityChanged: ((Int) -> Void)?
  
  private var quantity: Int = 0 {
    didSet {
      updateView()
      onQuantityChanged?(quantity)
    }
  }
  
  private let stackView = UIStackView()
  private let addButton = UIButton(type: .system)
  private let removeButton = UIButton(type: .system)
  private let quantityLabel = UILabel()
  private let addItemButton = UIButton(type: .system)
  
  init() {
    super.init(frame: .zero)
    setupViews()
    updateView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateQuantity(_ newQuantity: Int) {
    quantity = newQuantity
  }
  
  private func setupViews() {
    backgroundColor = .systemBlue
    layer.cornerRadius = 10
    
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    stackView.spacing = 8
    
    removeButton.setTitle("-", for: .normal)
    removeButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
    removeButton.setTitleColor(.white, for: .normal)
    
    quantityLabel.textAlignment = .center
    quantityLabel.font = .systemFont(ofSize: 16, weight: .bold)
    quantityLabel.textColor = .white
    
    addButton.setTitle("+", for: .normal)
    addButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
    addButton.setTitleColor(.white, for: .normal)
    
    addItemButton.setTitle("Add to Cart", for: .normal)
    addItemButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
    addItemButton.setTitleColor(.white, for: .normal)
    
    addSubview(stackView)
    addSubview(addItemButton)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addItemButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      addItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      addItemButton.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func updateView() {
    if quantity == 0 {
      addItemButton.isHidden = false
      stackView.isHidden = true
    } else {
      addItemButton.isHidden = true
      stackView.isHidden = false
      stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
      stackView.addArrangedSubview(removeButton)
      stackView.addArrangedSubview(quantityLabel)
      stackView.addArrangedSubview(addButton)
      quantityLabel.text = "\(quantity)"
    }
  }
  
  @objc private func increaseQuantity() {
    quantity += 1
  }
  
  @objc private func decreaseQuantity() {
    if quantity > 0 {
      quantity -= 1
    }
  }
}
