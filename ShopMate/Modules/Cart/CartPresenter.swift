//
//  CartPresenter.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol CartPresenterProtocol: AnyObject {
}

class CartPresenter {
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol

    init(interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CartPresenter: CartPresenterProtocol {
}
