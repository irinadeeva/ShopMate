//
//  ItemSearchPresenter.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemSearchPresenterProtocol: AnyObject {
  func viewDidLoad()
}

// MARK: - State

enum ItemSearchDetailState {
  case initial, loading, failed(Error), data([Item])
}

final class ItemSearchPresenter {
  weak var view: ItemSearchViewProtocol?
  var router: ItemSearchRouterProtocol
  var interactor: ItemSearchInteractorProtocol
  private var state = ItemSearchDetailState.initial {
    didSet {
      stateDidChanged()
    }
  }

  init(interactor: ItemSearchInteractorProtocol, router: ItemSearchRouterProtocol) {
    self.interactor = interactor
    self.router = router
  }

  private func stateDidChanged() {
      switch state {
      case .initial:
        //TODO: change
          assertionFailure("can't move to initial state")
      case .loading:
//          view?.showLoading()
        interactor.fetchTasks()
      case .data(let items):
//          view?.fetchNfts(nfts)
//          view?.hideLoading()
        print(items)
      case .failed(let error):
//          let errorModel = makeErrorModel(error)
//          view?.hideLoading()
//          view?.showError(errorModel)
        print(error)
      }
  }
}

extension ItemSearchPresenter: ItemSearchPresenterProtocol {
  func viewDidLoad() {
    state = .loading
  }
}
