import UIKit

protocol CartViewProtocol: AnyObject, LoadingView, ErrorView {
  func displayItems(_ purchases: [Item: Int])
}

class CartViewController: UIViewController {
    // MARK: - Public
    var presenter: CartPresenterProtocol?
  var activityIndicator = UIActivityIndicatorView()
  private var purchases: [Item: Int] = [:]


  private let tableView: UITableView = {
      let table = UITableView()
      table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
      view.addSubview(tableView)
      tableView.frame = view.bounds
      tableView.delegate = self
      tableView.dataSource = self
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

  @objc private func shareTapped() {
//      presenter?.didTapShareButton()
  }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
  func displayItems(_ purchases: [Item: Int]) {
    self.purchases = purchases
      tableView.reloadData()
  }
}



extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return purchases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

      let item = Array(purchases.keys)[indexPath.row]
      let quantity = purchases[item] ?? 0
      cell.textLabel?.text = "\(item.title) - \(item.price) x \(quantity)"
      return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      presenter?.didSelectItem(purchases[indexPath.row])
    }
}
