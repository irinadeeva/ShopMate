import UIKit

final class ItemDetailModuleBuilder {
  static func build(for id: Int) -> ItemDetailViewController {
    let interactor = ItemDetailInteractor()
    let router = ItemDetailRouter()
    let presenter = ItemDetailPresenter(interactor: interactor, router: router, id: id)
    let viewController = ItemDetailViewController()
    
    presenter.view  = viewController
    viewController.presenter = presenter
    interactor.presenter = presenter
    router.viewController = viewController
    return viewController
  }
}
