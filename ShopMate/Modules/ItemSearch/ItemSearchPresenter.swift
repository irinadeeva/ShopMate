//
//  ItemSearchPresenter.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemSearchPresenterProtocol: AnyObject {
}

class ItemSearchPresenter {
    weak var view: ItemSearchViewProtocol?
    var router: ItemSearchRouterProtocol
    var interactor: ItemSearchInteractorProtocol

    init(interactor: ItemSearchInteractorProtocol, router: ItemSearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension ItemSearchPresenter: ItemSearchPresenterProtocol {
}
