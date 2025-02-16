protocol ItemSearchRouterProtocol {
  func navigateToItemDetail(for itemId: Int)
  func navigateToCart()
}

final class ItemSearchRouter: ItemSearchRouterProtocol {
    weak var viewController: ItemSearchViewController?

  func navigateToItemDetail(for itemId: Int) {
    let itemDetailViewController = ItemDetailModuleBuilder.build(for: itemId)
    viewController?.navigationController?.pushViewController(itemDetailViewController, animated: true)
  }

  func navigateToCart() {
    let cartViewController = CartModuleBuilder.build()
    viewController?.navigationController?.pushViewController(cartViewController, animated: true)
  }

}
