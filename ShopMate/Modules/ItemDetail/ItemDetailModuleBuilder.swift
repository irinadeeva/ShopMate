//
//  ItemDetailModuleBuilder.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

class ItemDetailModuleBuilder {
    static func build() -> ItemDetailViewController {
        let interactor = ItemDetailInteractor()
        let router = ItemDetailRouter()
        let presenter = ItemDetailPresenter(interactor: interactor, router: router)
        let viewController = ItemDetailViewController()
      
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
