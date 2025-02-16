import Foundation

enum ItemDetailState {
  case initial, loading, data(Purchase), failed(Error)
}

protocol ItemDetailPresenterProtocol: AnyObject {
  func viewDidLoad()
  func navigateBack()
  func getCachedImage(for images: [String]) -> [Data]
  func addToCart(_ purchase: Purchase)
}

final class ItemDetailPresenter {
    weak var view: ItemDetailViewProtocol?
    var router: ItemDetailRouterProtocol
    var interactor: ItemDetailInteractorInput
  let id: Int
  private var state: ItemDetailState = .initial {
    didSet {
      stateDidChanged()
    }
  }

    init(interactor: ItemDetailInteractorInput, router: ItemDetailRouterProtocol, id: Int) {
        self.interactor = interactor
        self.router = router
      self.id = id
    }

  private func stateDidChanged() {
    switch state {
    case .initial:
      assertionFailure("can't move to initial state")
    case .loading:
      view?.showLoadingAndBlockUI()
      interactor.fetchItem(with: id)
    case .data(let item):
      view?.fetchItem(item)
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

extension ItemDetailPresenter: ItemDetailPresenterProtocol {
  func viewDidLoad() {
    state = .loading
  }

  func getCachedImage(for images: [String]) -> [Data] {
    return interactor.fetchCachedImage(for: images)
  }

  func navigateBack() {
    router.navigateBack()
  }

  func addToCart(_ purchase: Purchase) {
    interactor.addToCart(purchase)
  }
}

extension ItemDetailPresenter: ItemDetailInteractorOutput {
  func didFetchItem(_ purchase: Purchase) {
    state = .data(purchase)
  }
  
  func didFailToFetchItem(with error: any Error) {
    state = .failed(error)
  }
}
