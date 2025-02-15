import UIKit

final class CartModuleBuilder {
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
