import Foundation

protocol PurchaseServiceProtocol {
  func storePurchase(_ purchase: Purchase)
  func storeItems(_ items: [Item])
  func getPurchases() -> [Purchase]
  func getPurchase(for id: Int) -> Purchase?
}

final class PurchaseService {
  static let shared = PurchaseService()
  private let storage = PurchaseStorage()

  private init() {}
}

extension PurchaseService: PurchaseServiceProtocol {
  func getPurchases() -> [Purchase] {
   let purchases = storage.getPurchases()
    let sortedPurchases = purchases.sorted { $0.item.id < $1.item.id }
    return sortedPurchases
  }
  
  func getPurchase(for id: Int) -> Purchase? {
    storage.getPurchase(for: id)
  }

  func getPurchaseInCart() -> [Purchase] {
    storage.getPurchaseInCart()
  }

  func storePurchase(_ purchase: Purchase) {
    storage.storePurchase(purchase)
  }

  func storeItems(_ items: [Item]) {
    for item in items {
      storage.storePurchase(Purchase(item: item, quantity: 0))
    }
  }
}


