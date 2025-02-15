protocol CartInteractorInput: AnyObject {
  func fetchPurchases()
}

protocol CartInteractorOutput: AnyObject {
  func didFetchPurchases(_ purchases: [Purchase])
  func didFailWithError(_ error: Error)
}

class CartInteractor: CartInteractorInput {
  weak var presenter: CartInteractorOutput?
  
  func fetchPurchases() {
    let purchases = PurchaseService.shared.getPurchaseInCart()
    
    presenter?.didFetchPurchases(purchases)
  }
}
