import UIKit

protocol ItemSearchViewProtocol: AnyObject, ErrorView, LoadingView {
  func fetchItems(_ purchases: [Purchase])
}

class ItemSearchViewController: UIViewController {
    // MARK: - Public
    var presenter: ItemSearchPresenterProtocol?
  lazy var activityIndicator = UIActivityIndicatorView()
  private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                        leftInset: 16,
                                                        rightInset: 16,
                                                        cellSpacing: 7)

  private var purchases: [Purchase] = []
  private var hints: [String] = []
  private var query: String = ""
  private let searchController: UISearchController = {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.searchBar.placeholder = "Поиск"
      return searchController
  }()

  private lazy var itemsCollection: UICollectionView = {
      let collectionView = UICollectionView(
          frame: .zero,
          collectionViewLayout: UICollectionViewFlowLayout()
      )

      collectionView.register(
         ItemCell.self,
          forCellWithReuseIdentifier: ItemCell.identifier)

      collectionView.isScrollEnabled = true
      collectionView.backgroundColor = .background
      return collectionView
  }()

  private lazy var emptyLabel: UILabel = {
      let label = UILabel()
      label.text = "Ничего не найдено"
      label.textColor = .textColor
      label.isHidden = true
      return label
  }()

  private lazy var suggestionsTableView: UITableView = {
      let tableView = UITableView()
      tableView.backgroundColor = .background
      tableView.isHidden = true
      tableView.isScrollEnabled = false
      tableView.register(SuggestedHintTableViewCell.self,
                         forCellReuseIdentifier: SuggestedHintTableViewCell.identifier)
      return tableView
  }()

  private lazy var cartButton: UIBarButtonItem = {
      let button = UIBarButtonItem(
          image: UIImage(systemName: "cart.fill"), // Replace with a custom image if necessary
          style: .plain,
          target: self,
          action: #selector(cartButtonTapped)
      )
      return button
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
private extension ItemSearchViewController {
    func initialize() {
      view.backgroundColor = .background

      itemsCollection.delegate = self
      itemsCollection.dataSource = self

      suggestionsTableView.delegate = self
      suggestionsTableView.dataSource = self

      [itemsCollection,
       emptyLabel,
       suggestionsTableView,
       activityIndicator
      ].forEach {
          view.addSubview($0)
          $0.translatesAutoresizingMaskIntoConstraints = false
      }

      NSLayoutConstraint.activate([
          activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

          //TODO: check if zero is okey here
          suggestionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
          suggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          suggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          suggestionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

          emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

          itemsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          itemsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          itemsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          itemsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      setUpSearchBar()
    }

  func setUpSearchBar() {
      searchController.searchBar.delegate = self
      searchController.searchResultsUpdater = self
      navigationItem.searchController = searchController

    navigationItem.rightBarButtonItem = cartButton
  }

  func updateSuggestions(for query: String) {
//      let searchHistory = presenter.fetchHints()

//      let searchResults = searchHistory.filter { item in
//          item.localizedCaseInsensitiveContains(query)
//      }

      self.query = query
//      hints = searchResults

      suggestionsTableView.reloadData()
  }

  func showAllSearchHistory()
  {
//      let searchHistory = presenter.fetchHints()
//      hints = searchHistory
      self.query = ""
      suggestionsTableView.reloadData()
  }

  @objc func cartButtonTapped() {
    presenter?.showCart()
  }
}

// MARK: - ItemSearchViewProtocol
extension ItemSearchViewController: ItemSearchViewProtocol {
  func fetchItems(_ purchases: [Purchase]) {
    self.purchases = purchases
    print(purchases.count)

      if self.purchases.count != 0 {
          emptyLabel.isHidden = true
          suggestionsTableView.isHidden = true
          itemsCollection.isHidden = false
          itemsCollection.reloadData()
      } else {
          emptyLabel.isHidden = false
          suggestionsTableView.isHidden = true
          itemsCollection.isHidden = true
      }
  }
}

extension ItemSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ItemCell.identifier,
            for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }

      let item = purchases[indexPath.item].item

        let cachedImage = presenter?.getCachedImage(for: item.images)
          if let imageData = cachedImage {
            cell.updateImage(with: imageData)
        }

        cell.updateCell(with: item)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == purchases.count {
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
              self.presenter?.fetchItemsNextPage()
            }
        }
    }
}

extension ItemSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth,
                      height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
}

extension ItemSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      presenter?.showDetails(of: purchases[indexPath.row].item.id)
    }
}

extension ItemSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hints.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SuggestedHintTableViewCell.identifier,
            for: indexPath) as? SuggestedHintTableViewCell else {
            return UITableViewCell()
        }

        if query.isEmpty {
            cell.updateCell(with: hints[indexPath.row])
        } else {
            cell.set(term: hints[indexPath.row],
                     searchedTerm: query)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = hints[indexPath.row]
        searchController.searchBar.text = selectedSuggestion
        suggestionsTableView.isHidden = true
//        presenter.fetchPhotosFor(selectedSuggestion)
    }
}

extension ItemSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }

        itemsCollection.isHidden = false
        suggestionsTableView.isHidden = true

//        presenter.fetchPhotosFor(text)
    }
}

extension ItemSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        itemsCollection.isHidden = true
        suggestionsTableView.isHidden = false

        if !searchText.isEmpty {
            updateSuggestions(for: searchText)
        } else {
            showAllSearchHistory()
        }
    }
}

extension ItemSearchViewController: ItemCellDelegate {
  func didTapAddButton(in cell: ItemCell, with quality: Int) {
    guard let indexPath = itemsCollection.indexPath(for: cell) else { return }
    purchases[indexPath.row].quantity = quality
    
    let purchase = purchases[indexPath.row]
    
    //TODO: work with quality + - 0
    
    presenter?.addToCart(for: purchase)
  }
}
