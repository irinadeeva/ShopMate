import Foundation

protocol PurchaseStorageProtocol {
  func addNewPurchase(_ purchase: Purchase)
  func storePurchase(_ purchase: Purchase)
  func getPurchases() -> [Purchase]
  func getPurchase(for id: Int) -> Purchase?
  func getPurchaseInCart() -> [Purchase]
  func deletePurchase(for id: Int)
}

final class PurchaseStorage {
  private let storageKey = "purchases_storage"
  private var purchases: [Int: Purchase] = [:]
  
  init() {
    loadPurchases()
  }
  
  private func savePurchases() {
    let filteredPurchases = purchases.filter { $0.value.quantity > 0 }
    
    if let encoded = try? JSONEncoder().encode(filteredPurchases) {
      UserDefaults.standard.set(encoded, forKey: storageKey)
    }
  }
  
  private func loadPurchases() {
    if let savedData = UserDefaults.standard.data(forKey: storageKey),
       let decoded = try? JSONDecoder().decode([Int: Purchase].self, from: savedData) {
      purchases = decoded
    }
  }
  
}

extension PurchaseStorage: PurchaseStorageProtocol {
  func addNewPurchase(_ purchase: Purchase) {
    let id = purchase.item.id
    if purchases[id] == nil {
      purchases[id] = purchase
    }
  }
  
  func storePurchase(_ purchase: Purchase) {
    let id = purchase.item.id
    purchases[id] = purchase
    
    savePurchases()
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
  
  func deletePurchase(for id: Int) {
    let purchase = purchases[id]
    
    guard var purchase = purchase else { return }
    purchase.quantity = 0
    
    purchases[id] = purchase
    savePurchases()
  }
}
