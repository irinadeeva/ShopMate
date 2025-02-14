protocol ItemSearchRouterProtocol {
  func navigateToItemDetail(for itemId: Int)
}

class ItemSearchRouter: ItemSearchRouterProtocol {
    weak var viewController: ItemSearchViewController?

  func navigateToItemDetail(for itemId: Int) {
    let itemDetailViewController = ItemDetailModuleBuilder.build(for: itemId)
    viewController?.navigationController?.pushViewController(itemDetailViewController, animated: true)
  }
}
