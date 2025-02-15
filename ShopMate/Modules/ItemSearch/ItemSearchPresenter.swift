import Foundation

protocol ItemSearchPresenterProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear()
  func fetchItemsNextPage()
  func getCachedImage(for images: [String]) -> Data?
  func showDetails(of id: Int)
  func showCart()
  func addToCart(for purchase: Purchase)
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
        interactor.fetchItems(for: lastOffset)
      case .updating:
        view?.showLoadingAndBlockUI()
        interactor.fetchUpdatedItems()
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
//    state = .updating
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
}

extension ItemSearchPresenter: ItemSearchInteractorOutput {
  func didFetchItems(_ purchases: [Purchase]) {
    state = .data(purchases)
  }
  
  func didFailToFetchItems(with error: any Error) {
    state = .failed(error)
  }
}
