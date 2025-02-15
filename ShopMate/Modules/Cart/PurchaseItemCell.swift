import UIKit
//
//class PurchaseItemCell: UITableViewCell {
//    static let identifier = "PurchaseItemCell"
//
//    private let itemImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let priceLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let quantityLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let stepper: UIStepper = {
//        let stepper = UIStepper()
//        stepper.minimumValue = 1
//        stepper.translatesAutoresizingMaskIntoConstraints = false
//        return stepper
//    }()
//
//    private let removeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Remove", for: .normal)
//        button.setTitleColor(.red, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    var onQuantityChange: ((Int) -> Void)?
//    var onRemove: (() -> Void)?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//        stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
//        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        contentView.addSubview(itemImageView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(priceLabel)
//        contentView.addSubview(quantityLabel)
//        contentView.addSubview(stepper)
//        contentView.addSubview(removeButton)
//
//        NSLayoutConstraint.activate([
//            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            itemImageView.widthAnchor.constraint(equalToConstant: 50),
//            itemImageView.heightAnchor.constraint(equalToConstant: 50),
//
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -10),
//
//            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
//            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//
//            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            quantityLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
//
//            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
//
//            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//
//    func configure(with item: Item, quantity: Int) {
//        titleLabel.text = item.title
//        priceLabel.text = "$\(item.price)"
//        quantityLabel.text = "x\(quantity)"
//        stepper.value = Double(quantity)
//        if let imageUrl = item.images.first, let url = URL(string: imageUrl) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.itemImageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
//    }
//
//    @objc private func stepperChanged() {
//        let newQuantity = Int(stepper.value)
//        quantityLabel.text = "x\(newQuantity)"
//        onQuantityChange?(newQuantity)
//    }
//
//    @objc private func removeTapped() {
//        onRemove?()
//    }
//}


protocol PurchaseItemCellDelegate: AnyObject {
    func didTapDeleteButton()
}

final class PurchaseItemCell: UITableViewCell {
  static let identifier = "PurchaseItemCell"
    weak var delegate: PurchaseItemCellDelegate?
    private var id: Int?

    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
      cardView.backgroundColor = .background
        return cardView
    }()

    private lazy var cardImageView: UIImageView = {
        let  cardImageView = UIImageView()
        cardImageView.layer.cornerRadius = 12
        cardImageView.layer.masksToBounds = true
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        return  cardImageView
    }()


    private lazy var nameCardLabel: UILabel = {
        let nameCardLabel = UILabel()
        nameCardLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      nameCardLabel.textColor = .textColor
        nameCardLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameCardLabel
    }()

    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      moneyLabel.textColor = .textColor
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyLabel
    }()

    private lazy var cartButton: UIButton = {
        let cartButton = UIButton()
      cartButton.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        cartButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        return cartButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
        setupLayoutCardView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private  func addSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(cartButton)

        [cardImageView, nameCardLabel, moneyLabel].forEach {
            cardView.addSubview($0)
        }
    }

    private func setupLayoutCardView() {
        NSLayoutConstraint.activate([
            cardImageView.heightAnchor.constraint(equalToConstant: 108),
            cardImageView.widthAnchor.constraint(equalToConstant: 108),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),

            nameCardLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            nameCardLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),

            moneyLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            moneyLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 78)
        ])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 108),
            cardView.widthAnchor.constraint(equalToConstant: 203),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            cartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with item: Item, quantity: Int) {


        id = item.id

      nameCardLabel.text = item.title
      moneyLabel.text = "$\(item.price)"
//      quantityLabel.text = "x\(quantity)"
//      stepper.value = Double(quantity)
      if let imageUrl = item.images.first, let url = URL(string: imageUrl) {
          DispatchQueue.global().async {
              if let data = try? Data(contentsOf: url) {
                  DispatchQueue.main.async {
                      self.cardImageView.image = UIImage(data: data)
                  }
              }
          }
      }
    }

    @objc private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
    }
}
