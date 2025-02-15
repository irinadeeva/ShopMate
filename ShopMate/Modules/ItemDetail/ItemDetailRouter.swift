protocol ItemDetailRouterProtocol {
  func navigateBack()
}

class ItemDetailRouter: ItemDetailRouterProtocol {
    weak var viewController: ItemDetailViewController?

  func navigateBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
}
