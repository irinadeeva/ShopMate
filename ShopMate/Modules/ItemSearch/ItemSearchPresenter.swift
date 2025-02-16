import Foundation

protocol ItemSearchPresenterProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear()
  func fetchItemsNextPage()
  func getCachedImage(for images: [String]) -> Data?
  func showDetails(of id: Int)
  func showCart()
  func addToCart(for purchase: Purchase)
  func fetchHints() -> [String]
  func fetchItemsFor(_ text: String)
  func fetchFilteredItemsFor(priceMax: Int?, categoryId: Int?)
  func fetchCategory()
}

// MARK: - State

enum ItemSearchDetailState {
  case initial, loading, updating, failed(Error), data([Purchase])
}

final class ItemSearchPresenter {
  weak var view: ItemSearchViewProtocol?
  var router: ItemSearchRouterProtocol
  var interactor: ItemSearchInteractorInput
  private var imageCache = NSCache<NSString, NSData>()
  private var lastOffset: Int = 0
  private var searchText: String = ""
  private var priceMax: Int?
  private var categoryId: Int?
  private var state = ItemSearchDetailState.initial {
    didSet {
      stateDidChanged()
    }
  }

  init(interactor: ItemSearchInteractorInput, router: ItemSearchRouterProtocol) {
    self.interactor = interactor
    self.router = router
  }

  private func stateDidChanged() {
      switch state {
      case .initial:
        //TODO: change
          assertionFailure("can't move to initial state")
      case .loading:
        view?.showLoadingAndBlockUI()
        interactor.fetchItems(for: lastOffset, searchText: searchText, priceMax: priceMax, categoryId: categoryId)
      case .updating:
        view?.showLoadingAndBlockUI()
        interactor.fetchUpdatedItems(searchText, priceMax: priceMax, categoryId: categoryId)
      case .data(let items):
        view?.fetchItems(items)
        view?.hideLoadingAndUnblockUI()
      case .failed(let error):
          let errorModel = makeErrorModel(error)
        view?.hideLoadingAndUnblockUI()
          view?.showError(errorModel)
      }
  }

  private func makeErrorModel(_ error: Error) -> ErrorModel {
    let message: String

    if let errorWithMessage = error as? ErrorWithMessage {
      message = errorWithMessage.message
    } else {
      message = "An unknown error occurred. Please try again later."
    }

    let actionText = "Repeat"
    return ErrorModel(message: message,
                      actionText: actionText) { [weak self] in
      self?.state = .loading
    }
  }
}

extension ItemSearchPresenter: ItemSearchPresenterProtocol {
  func viewDidLoad() {
    state = .loading
  }

  func viewWillAppear() {
    state = .updating
  }

  func fetchItemsNextPage() {
    if lastOffset < 60 {
      lastOffset += 10
      state = .loading
    }
  }

  func getCachedImage(for images: [String]) -> Data? {
    if let firstImageUrlString = images.first {
      return interactor.fetchItemFirstImage(for: firstImageUrlString)
    }

    return nil
  }

  func showDetails(of id: Int) {
    router.navigateToItemDetail(for: id)
  }

  func showCart() {
    router.navigateToCart()
  }

  func addToCart(for purchase: Purchase) {
    interactor.addToCart(for: purchase)
  }

  func fetchHints() -> [String] {
    interactor.fetchSearchHistory()
  }

  func fetchItemsFor(_ text: String) {
    lastOffset = 0
    searchText = text
    state = .loading
  }

  func fetchFilteredItemsFor(priceMax: Int?, categoryId: Int?) {
    lastOffset = 0
    self.priceMax = priceMax
    self.categoryId = categoryId
    state = .loading
  }

  func fetchCategory() {
    interactor.fetchCategory()
  }
}

extension ItemSearchPresenter: ItemSearchInteractorOutput {
  func didFetchItems(_ purchases: [Purchase]) {
    state = .data(purchases)
  }
  
  func didFailToFetchItems(with error: any Error) {
    state = .failed(error)
  }

  func didFetchCategories(_ categories: [Category]) {
    view?.fetchCategories(categories)
  }
}
