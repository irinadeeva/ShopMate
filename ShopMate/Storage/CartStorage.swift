import Foundation

protocol CartStorageProtocol {
    func storePurchase(_ item: Item)
    func getPurchase() -> [Item: Int]
}

final class CartStorage {
    private var purchases: [Item: Int] = [:]
}

extension CartStorage: CartStorageProtocol {
    func storePurchase(_ item: Item) {
        if let count = purchases[item] {
            purchases[item] = count + 1
        } else {
            purchases[item] = 1
        }
    }

    func getPurchase() -> [Item: Int] {
      return purchases.isEmpty ? [:] : purchases
    }
}
