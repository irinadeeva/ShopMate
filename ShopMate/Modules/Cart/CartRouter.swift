protocol CartRouterProtocol {
  func navigateToItemDetail(for itemId: Int)
}

final class CartRouter: CartRouterProtocol {
  weak var viewController: CartViewController?
  
  func navigateToItemDetail(for itemId: Int) {
    let itemDetailViewController = ItemDetailModuleBuilder.build(for: itemId)
    viewController?.navigationController?.pushViewController(itemDetailViewController, animated: true)
  }
}
