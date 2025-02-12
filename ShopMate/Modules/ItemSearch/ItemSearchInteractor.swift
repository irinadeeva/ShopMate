//
//  ItemSearchInteractor.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemSearchInteractorProtocol: AnyObject {
  func fetchTasks()
}

class ItemSearchInteractor: ItemSearchInteractorProtocol {
    weak var presenter: ItemSearchPresenterProtocol?

  func fetchTasks() {
    ItemService.shared.fetchItems { [weak self] items in
      guard let self = self else { return }
//      self.presenter?.viewDidLoad(items: items)
    }
  }
}
