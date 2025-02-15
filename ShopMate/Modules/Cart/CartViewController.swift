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
}

// MARK: - Private functions
private extension CartViewController {
  
  func initialize() {
    view.backgroundColor = .background
    view.addSubview(tableView)
//    tableView.frame = view.bounds
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
          NSLayoutConstraint.activate([
              tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
          ])
  }
  
  @objc private func shareTapped() {
    //      presenter?.didTapShareButton()
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
    
    cell.configure(purchase)
    //        cell.onQuantityChange = { [weak self] newQuantity in
    //            self?.purchases[item] = newQuantity
    //            self?.tableView.reloadData()
    //        }
    //        cell.onRemove = { [weak self] in
    //            self?.purchases.removeValue(forKey: item)
    //            self?.tableView.reloadData()
    //        }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //      presenter?.didSelectItem(purchases[indexPath.row])
  }
}
