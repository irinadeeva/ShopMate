import Foundation

protocol CartInteractorInput: AnyObject {
  func fetchPurchases()
  func detetePurchase(_ id: Int)
  func fetchItemFirstImage(for url: String) -> Data?
  func addToCart(for purchase: Purchase)
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

  func detetePurchase(_ id: Int) {
    PurchaseService.shared.deletePurchase(for: id)

    fetchPurchases()
  }

  func fetchItemFirstImage(for url: String) -> Data? {
    let data = ImageCacheService.shared.getImage(for: url)
    return data
  }

  func addToCart(for purchase: Purchase) {
    PurchaseService.shared.storePurchase(purchase)

    if purchase.quantity == 0 {
      fetchPurchases()
    }
  }
}
