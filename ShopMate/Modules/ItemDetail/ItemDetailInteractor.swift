import Foundation

protocol ItemDetailInteractorInput: AnyObject {
  func fetchItem(with id: Int)
  func fetchCachedImage(for images: [String]) -> [Data]
  func addToCart(_ purchase: Purchase)
}

protocol ItemDetailInteractorOutput: AnyObject {
  func didFetchItem(_ purchase: Purchase)
  func didFailToFetchItem(with error: Error)
}

class ItemDetailInteractor: ItemDetailInteractorInput {
  weak var presenter: ItemDetailInteractorOutput?

  func fetchItem(with id: Int) {
    let purchasedItem = PurchaseService.shared.getPurchase(for: id)

    if let purchasedItem  {
      presenter?.didFetchItem(purchasedItem)
    } else {
//TODO: do Error
//      presenter?.didFailToFetchItem(with: )
    }
  }

  func fetchCachedImage(for images: [String]) -> [Data] {
    var datas: [Data] = []

    for image in images {
      if let data = ImageCacheService.shared.getImage(for: image) {
        datas.append(data)
      }
    }

    return datas
  }

  func addToCart(_ purchase: Purchase) {
    PurchaseService.shared.storePurchase(purchase)
  }

  private func cacheImages(for item: Item) {
    let images = item.images
    for image in images {
      ImageCacheService.shared.storeImage(for: image)
    }
  }
}
