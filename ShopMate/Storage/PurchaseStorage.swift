import Foundation

protocol PurchaseStorageProtocol {
  func storePurchase(_ purchase: Purchase)
  func getPurchases() -> [Purchase]
  func getPurchase(for id: Int) -> Purchase?
  func getPurchaseInCart() -> [Purchase]
}

final class PurchaseStorage {
  private var purchases: [Int: Purchase] = [:]
}

extension PurchaseStorage: PurchaseStorageProtocol {
  func storePurchase(_ purchase: Purchase) {
    let id = purchase.item.id
    purchases[id] = purchase
    print(purchases[id])
  }

  func getPurchases() -> [Purchase] {
    let purchases: [Purchase] = Array(self.purchases.values)
    return purchases
  }

  func getPurchaseInCart() -> [Purchase] {
    let purchases: [Purchase] = Array(self.purchases.values)
      .filter{ $0.quantity > 0 }
    return purchases
  }

  func getPurchase(for id: Int) -> Purchase? {
    let purchase = purchases[id]
    return purchase
  }
}
