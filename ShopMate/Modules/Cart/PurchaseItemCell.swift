import UIKit

protocol PurchaseItemCellDelegate: AnyObject {
  func didTapDeleteButton(_ cell: PurchaseItemCell)
  func didTapAddButton(in cell: PurchaseItemCell, with quality: Int)
}

final class PurchaseItemCell: UITableViewCell {
  static let identifier = "PurchaseItemCell"
  weak var delegate: PurchaseItemCellDelegate?
  private var id: Int?

  private lazy var cardImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(resource: ImageResource.placeholder)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .textColor
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = .left
    return label
  }()

  private lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .green
    return label
  }()

  private lazy var cartButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "trash"), for: .normal)
    button.tintColor = .red
    button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    return button
  }()

  private let quantitySelector = QuantitySelectorView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.backgroundColor = .background
    contentView.layer.masksToBounds = false

    [cardImageView, titleLabel, moneyLabel, quantitySelector, cartButton].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      cardImageView.heightAnchor.constraint(equalToConstant: 108),
      cardImageView.widthAnchor.constraint(equalToConstant: 108),
      cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      cardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

      titleLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 16),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

      moneyLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 16),
      moneyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      moneyLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

      quantitySelector.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 16),
      quantitySelector.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
      quantitySelector.heightAnchor.constraint(equalToConstant: 30),
      quantitySelector.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

      cartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

      cartButton.heightAnchor.constraint(equalToConstant: 40),
      cartButton.widthAnchor.constraint(equalToConstant: 40)
    ])

    quantitySelector.onQuantityChanged = { [weak self] quantity in
      guard let self else { return }
      delegate?.didTapAddButton(in: self, with: quantity)
    }
  }

  func configure(_ purchaseItem: Purchase) {
    let item = purchaseItem.item
    let quantity = purchaseItem.quantity
    id = item.id

    titleLabel.text = item.title
    moneyLabel.text = "$\(item.price)"
    quantitySelector.updateQuantity(quantity)
  }

  func updateImage(with data: Data) {
    cardImageView.image = UIImage(data: data)
  }

  @objc private func didTapDeleteButton() {
    delegate?.didTapDeleteButton(self)
  }
}
