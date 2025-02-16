import Foundation

protocol PurchaseServiceProtocol {
  func storePurchase(_ purchase: Purchase)
  func storeItems(_ items: [Item])
  func getPurchases() -> [Purchase]
  func getPurchase(for id: Int) -> Purchase?
  func deletePurchase(for id: Int)
  func getPurchases(priceMax: Int?, categoryId: Int?) -> [Purchase]
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
  
  func getPurchases(for searchText: String) -> [Purchase] {
    let purchases = storage.getPurchases()
    let sortedPurchases = purchases.sorted { $0.item.id < $1.item.id }
    let filteredPurchases = sortedPurchases.filter {
      $0.item.title.lowercased().contains(searchText.lowercased())
    }
    return filteredPurchases
  }
  
  func getPurchases(priceMax: Int?, categoryId: Int?) -> [Purchase] {
    let purchases = storage.getPurchases()
    let sortedPurchases = purchases.sorted { $0.item.id < $1.item.id }
    
    let filteredPurchases = sortedPurchases.filter { purchase in
      let matchesCategory = categoryId == nil || purchase.item.category.id == categoryId!
      let matchesPrice = priceMax == nil || purchase.item.price <= priceMax!
      return matchesPrice && matchesCategory
    }
    
    return filteredPurchases
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
      storage.addNewPurchase(Purchase(item: item, quantity: 0))
    }
  }
  
  func deletePurchase(for id: Int) {
    storage.deletePurchase(for: id)
  }
}


