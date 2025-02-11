//
//  ItemSearchModuleBuilder.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

final class ItemSearchModuleBuilder {
  static func build() -> ItemSearchViewController {
    let interactor = ItemSearchInteractor()
    let router = ItemSearchRouter()
    let presenter = ItemSearchPresenter(interactor: interactor, router: router)
    let viewController = ItemSearchViewController()

    viewController.presenter = presenter
    presenter.view  = viewController
    interactor.presenter = presenter
    router.viewController = viewController
    return viewController
  }
}
