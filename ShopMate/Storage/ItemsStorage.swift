import Foundation

final class ItemsStorage {
  private var storageLoaded: [Item] = []
  private var storageById: [Int: Item] = [:]
  private var storageBySearch: [String: [Item]] = [:]

  func saveLoadedItems(_ items: [Item]) {
    storageLoaded.append(contentsOf: items)
    saveItems(items)
  }

  private func saveItems(_ items: [Item]) {
    for item in items {
      storageById[item.id] = item
    }
  }

  func getLoadedItems() -> [Item] {
    storageLoaded
  }

  func getItem(with id: Int) -> Item? {
     storageById[id]
  }
}
