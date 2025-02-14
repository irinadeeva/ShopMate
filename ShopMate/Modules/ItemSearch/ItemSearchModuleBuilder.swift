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
