import Foundation

protocol CartServiceProtocol {
  func storePurchase(_ item: Item)
  func getPurchase() -> [Item : Int]
}

final class CartService {
  static let shared = CartService()
  private let storage = CartStorage()

  private init() {}
}

extension CartService: CartServiceProtocol {
  func storePurchase(_ item: Item) {
    storage.storePurchase(item)
  }
  
  func getPurchase() -> [Item : Int] {
    storage.getPurchase()
  }
}


