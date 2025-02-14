protocol CartInteractorInput: AnyObject {
  func fetchPurchases()
}

protocol CartInteractorOutput: AnyObject {
  func didFetchPurchases(_ purchases: [Item: Int])
  func didFailWithError(_ error: Error)
}

class CartInteractor: CartInteractorInput {
  weak var presenter: CartInteractorOutput?

  func fetchPurchases() {
    let purchases = CartService.shared.getPurchase()

    presenter?.didFetchPurchases(purchases)
  }
}
