import Foundation

protocol ItemSearchInteractorInput: AnyObject {
  func fetchItems(for offset: Int, searchText: String)
  func fetchItemFirstImage(for url: String) -> Data?
  func addToCart(for purchase: Purchase)
  func fetchUpdatedItems(_ searchText: String)
  func fetchSearchHistory() -> [String]
}

protocol ItemSearchInteractorOutput: AnyObject {
  func didFetchItems(_ purchases: [Purchase])
  func didFailToFetchItems(with error: Error)
}

final class ItemSearchInteractor: ItemSearchInteractorInput {
  weak var presenter: ItemSearchInteractorOutput?

  func fetchItems(for offset: Int, searchText: String) {

    if searchText.isEmpty {
      fetchRandomItems(for: offset, searchText: searchText)
    } else {
      fetchSearchedItems(for: offset, searchText: searchText)
    }
  }

  private func fetchRandomItems(for offset: Int, searchText: String) {
    ItemService.shared.fetchItems(for: offset, searchText: searchText) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(var items):

        for i in 0..<items.count {
          items[i].images = Item.cleanImages( items[i].images)
        }

        cacheFirstImage(for: items)
        addToPurchase(for: items)

        let purchasedItems = PurchaseService.shared.getPurchases()
        self.presenter?.didFetchItems(purchasedItems)
      case .failure(let error):
        self.presenter?.didFailToFetchItems(with: error)
      }
    }
  }

  private func fetchSearchedItems(for offset: Int, searchText: String) {
    ItemService.shared.fetchItems(for: offset, searchText: searchText) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(var items):

        for i in 0..<items.count {
          items[i].images = Item.cleanImages( items[i].images)
        }

        cacheFirstImage(for: items)
        addToPurchase(for: items)

        let purchasedItems = PurchaseService.shared.getPurchases(for: searchText)

        if !searchText.isEmpty {
          SearchHistoryService.shared.appendSearchHistory(searchText)
        }

        self.presenter?.didFetchItems(purchasedItems)
      case .failure(let error):
        self.presenter?.didFailToFetchItems(with: error)
      }
    }
  }

  func fetchUpdatedItems(_ searchText: String) {
    var purchasedItems: [Purchase] = []
    if searchText.isEmpty {
      purchasedItems = PurchaseService.shared.getPurchases()
    } else {
      purchasedItems = PurchaseService.shared.getPurchases(for: searchText)
    }

    self.presenter?.didFetchItems(purchasedItems)
  }

  func fetchItemFirstImage(for url: String) -> Data? {
    let data = ImageCacheService.shared.getImage(for: url)
    return data
  }

  func addToCart(for purchase: Purchase) {
    PurchaseService.shared.storePurchase(purchase)
  }

  private func cacheFirstImage(for items: [Item]) {
    for item in items {

      if let image = item.images.first {
        ImageCacheService.shared.storeImage(for: image)
      }
    }
  }

  private func addToPurchase(for items: [Item]) {
    PurchaseService.shared.storeItems(items)
  }

  func fetchSearchHistory() -> [String] {
    SearchHistoryService.shared.getSearchHistory()
  }
}
