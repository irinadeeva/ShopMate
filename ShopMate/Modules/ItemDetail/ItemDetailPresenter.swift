//
//  ItemDetailPresenter.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemDetailPresenterProtocol: AnyObject {
}

class ItemDetailPresenter {
    weak var view: ItemDetailViewProtocol?
    var router: ItemDetailRouterProtocol
    var interactor: ItemDetailInteractorProtocol

    init(interactor: ItemDetailInteractorProtocol, router: ItemDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension ItemDetailPresenter: ItemDetailPresenterProtocol {
}
