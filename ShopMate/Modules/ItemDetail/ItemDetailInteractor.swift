import Foundation

protocol ItemDetailInteractorInput: AnyObject {
  func fetchItem(with id: Int)
  func fetchCachedImage(for images: [String]) -> [Data]
}

protocol ItemDetailInteractorOutput: AnyObject {
  func didFetchItem(_ item: Item)
  func didFailToFetchItem(with error: Error)
}

class ItemDetailInteractor: ItemDetailInteractorInput {
  weak var presenter: ItemDetailInteractorOutput?

  func fetchItem(with id: Int) {
    let item = ItemService.shared.fetchItem(for: id)



    if let item {
      presenter?.didFetchItem(item)
    } else {
//TODO: error
//      presenter?.didFailToFetchItem(with: Error())
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


  private func cacheImages(for item: Item) {
    let images = item.images
    for image in images {
        ImageCacheService.shared.storeImage(for: image)
    }
  }
}
