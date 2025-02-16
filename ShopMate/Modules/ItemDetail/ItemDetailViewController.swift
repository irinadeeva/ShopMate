import UIKit

protocol ItemDetailViewProtocol: AnyObject, ErrorView, LoadingView {
  func fetchItem(_ purchase: Purchase)
}

final class ItemDetailViewController: UIViewController {
  var activityIndicator = UIActivityIndicatorView()
  var presenter: ItemDetailPresenterProtocol?
  private var purchase: Purchase?

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .textColor
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.numberOfLines = 0
    return label
  }()

  private let itemDescription: UILabel = {
    let label = UILabel()
    label.textColor = .textColor
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGreen
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()

  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    return label
  }()

  private let quantitySelector = QuantitySelectorView()

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
    presenter?.viewDidLoad()
  }
}

private extension ItemDetailViewController {
  func initialize() {
    view.backgroundColor = .background

    let backButton = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    navigationItem.leftBarButtonItem = backButton

    let shareButton = UIBarButtonItem(
      image: UIImage(systemName: "square.and.arrow.up"),
      style: .plain,
      target: self,
      action: #selector(didTapShareButton)
    )
    navigationItem.rightBarButtonItem = shareButton

    [imageView,
     titleLabel,
     itemDescription,
     priceLabel,
     categoryLabel,
     activityIndicator,
     quantitySelector].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      imageView.heightAnchor.constraint(equalToConstant: 250),

      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

      itemDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      itemDescription.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      itemDescription.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

      priceLabel.topAnchor.constraint(equalTo: itemDescription.bottomAnchor, constant: 8),
      priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

      categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
      categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

      quantitySelector.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
      quantitySelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      quantitySelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      quantitySelector.heightAnchor.constraint(equalToConstant: 44)
    ])


        quantitySelector.onQuantityChanged = { [weak self] quantity in
          self?.purchase?.quantity = quantity
          guard let purchase = self?.purchase else { return }
          self?.presenter?.addToCart(purchase)
        }
  }

  @objc func backButtonTapped() {
    presenter?.navigateBack()
  }

  @objc func didTapShareButton() {
    guard let item = purchase?.item else { return }
 
    let textToShare = "\(item.title) - \(item.price)$\n\(item.description)"
    let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

    present(activityVC, animated: true)
  }

  func updateUI(with purchase: Purchase) {
    self.purchase = purchase
    let item = purchase.item
    titleLabel.text = item.title
    itemDescription.text = item.description
    priceLabel.text = "Price: $\(item.price)"
    categoryLabel.text = "Category: \(item.category.name)"
    updateImageUI(images: item.images)
    if purchase.quantity != 0 {
      quantitySelector.updateQuantity(purchase.quantity)
    }
  }

  func updateImageUI(images: [String]) {
    guard let imageUrl = images.first, let url = URL(string: imageUrl) else {
      imageView.image = UIImage(named: "placeholder")
      return
    }

    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.imageView.image = image
        }
      } else {
        DispatchQueue.main.async {
          self.imageView.image = UIImage(named: "placeholder")
        }
      }
    }
  }
}

extension ItemDetailViewController: ItemDetailViewProtocol {
  func fetchItem(_ purchase: Purchase) {
    updateUI(with: purchase)
  }
}
