import UIKit

protocol ItemCellDelegate: AnyObject {
    func didTapAddButton(in cell: ItemCell, with quality: Int)
}

final class ItemCell: UICollectionViewCell {
  static let identifier = "ItemCell"

  weak var delegate: ItemCellDelegate?

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(resource: ImageResource.placeholder)
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .textColor
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = .left
    return label
  }()

//  private let addButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.setTitle("+", for: .normal)
//    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//    button.backgroundColor = .systemBlue
//    button.setTitleColor(.white, for: .normal)
//    button.layer.cornerRadius = 6
//    button.layer.masksToBounds = true
//    button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
//    return button
//  }()

  private let quantitySelector = QuantitySelectorView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCell(with item: Item) {
    titleLabel.text = item.title
  }

  func updateImage(with data: Data) {
    imageView.image = UIImage(data: data)
  }

//  @objc private func addButtonTapped() {
//    delegate?.didTapAddButton(in: self)
//  }

  private func setupUI() {
    contentView.backgroundColor = .background
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = false
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.1
    contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    contentView.layer.shadowRadius = 6

    [imageView, titleLabel, quantitySelector].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),

      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

//      addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//      addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//      addButton.heightAnchor.constraint(equalToConstant: 30),
//      addButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

      quantitySelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      quantitySelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      quantitySelector.heightAnchor.constraint(equalToConstant: 30),
      quantitySelector.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
    ])

    quantitySelector.onQuantityChanged = { [weak self] quantity in
//      self?.purchase?.quantity = quantity
//      guard let purchase = self?.purchase else { return }
//      self?.presenter?.addToCart(purchase)

      guard let self else { return }
      delegate?.didTapAddButton(in: self, with: quantity)
    }
  }
}
