import UIKit

protocol CartViewProtocol: AnyObject, LoadingView, ErrorView {
  func displayItems(_ purchases: [Purchase])
}

class CartViewController: UIViewController {
  // MARK: - Public
  var presenter: CartPresenterProtocol?
  var activityIndicator = UIActivityIndicatorView()
  private var purchases: [Purchase] = []
  
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.register(PurchaseItemCell.self, forCellReuseIdentifier: PurchaseItemCell.identifier)
    table.separatorStyle = .none
    //      table.allowsSelection = false
    table.dataSource = self
    table.delegate = self
    table.rowHeight = UITableView.automaticDimension
    table.estimatedRowHeight = 120
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
    presenter?.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    presenter?.viewWillAppear()
  }
}

// MARK: - Private functions
private extension CartViewController {
  
  func initialize() {
    view.backgroundColor = .background
    view.addSubview(tableView)

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
          NSLayoutConstraint.activate([
              tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
          ])
  }
  
  @objc private func shareTapped() {
    let purchaseList = purchases.map { "\($0.quantity)x \($0.item.title)" }.joined(separator: "\n")

        let activityViewController = UIActivityViewController(activityItems: [purchaseList], applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(activityViewController, animated: true, completion: nil)
  }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
  func displayItems(_ purchases: [Purchase]) {
    self.purchases = purchases
    tableView.reloadData()
  }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return purchases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseItemCell.identifier, for: indexPath) as? PurchaseItemCell else {
      return UITableViewCell()
    }

    let purchase = purchases[indexPath.row]

    let cachedImage = presenter?.getCachedImage(for: purchase.item.images)
      if let imageData = cachedImage {
        cell.updateImage(with: imageData)
    }
    
    cell.configure(purchase)
    cell.delegate = self

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let id = purchases[indexPath.row].item.id

    presenter?.didSelectItem(id)
  }
}

extension CartViewController: PurchaseItemCellDelegate {
  func didTapDeleteButton(_ cell: PurchaseItemCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }

    let id = purchases[indexPath.row].item.id
    presenter?.didTapDeleteButton(id)
  }
  
  func didTapAddButton(in cell: PurchaseItemCell, with quality: Int) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    purchases[indexPath.row].quantity = quality

    let purchase = purchases[indexPath.row]

    presenter?.addToCart(for: purchase)
  }
}
