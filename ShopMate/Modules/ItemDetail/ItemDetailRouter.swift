protocol ItemDetailRouterProtocol {
  func navigateBack()
}

final class ItemDetailRouter: ItemDetailRouterProtocol {
    weak var viewController: ItemDetailViewController?

  func navigateBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
}
