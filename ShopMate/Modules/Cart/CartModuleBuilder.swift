//
//  CartModuleBuilder.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

class CartModuleBuilder {
    static func build() -> CartViewController {
        let interactor = CartInteractor()
        let router = CartRouter()
        let presenter = CartPresenter(interactor: interactor, router: router)
        let viewController = CartViewController()
      
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
