enum CartState {
  case initial, loading, data([Purchase]), failed(Error)
}

protocol CartPresenterProtocol: AnyObject {
  func viewDidLoad()
  func didSelectItem(_ item: Item)
  //    func didTapShareButton()
  //    func didTapClearList()
  //    func didTapDeleteItem(_ item: Item)
  //    func didChangeItemQuantity(_ item: Item, quantity: Int)
}

class CartPresenter {
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorInput
  private var state = CartState.initial {
    didSet {
      stateDidChanged()
    }
  }

  init(interactor: CartInteractorInput, router: CartRouterProtocol) {
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
      interactor.fetchPurchases()
    case .data(let purchases):
      view?.displayItems(purchases)
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


extension CartPresenter: CartPresenterProtocol {
  func didSelectItem(_ item: Item) {
    
  }
  
  func viewDidLoad() {
    state = .loading
  }
}

extension CartPresenter: CartInteractorOutput {
  func didFetchPurchases(_ purchases: [Purchase]) {
    state = .data(purchases)
  }
  
  func didFailWithError(_ error: Error) {
    state = .failed(error)
  }
}
