import Foundation

protocol ItemSearchInteractorInput: AnyObject {
  func fetchItems(for offset: Int)
  func fetchItemFirstImage(for url: String) -> Data?
}

//protocol TaskListInteractorInput: AnyObject {
//  func fetchTasks()
//  func updateTaskItem(_ taskItem: TaskItem)
//  func deleteTaskItem(_ taskItem: TaskItem)
//}

protocol ItemSearchInteractorOutput: AnyObject {
  func didFetchItems(_ items: [Item])
  //  func didFetchItemImage(_ data: Data?)
  //  func didFetchTask(_ task: TaskItem)
  //  func didFetchId(_ taskId: UUID)
  func didFailToFetchItems(with error: Error)
}

class ItemSearchInteractor: ItemSearchInteractorInput {
  weak var presenter: ItemSearchInteractorOutput?

  func fetchItems(for offset: Int) {
    ItemService.shared.fetchItems(for: offset) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(var items):
        //TODO: вынести это
        for i in 0..<items.count {
          items[i].images = items[i].images
            .map { $0.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\\", with: "") }
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) }
        }

        cacheFirstImage(for: items)

        self.presenter?.didFetchItems(items)
      case .failure(let error):
        self.presenter?.didFailToFetchItems(with: error)
      }
    }
  }

  func fetchItemFirstImage(for url: String) -> Data? {
    let data = ImageCacheService.shared.getImage(for: url)
    return data
  }

  private func cacheFirstImage(for items: [Item]) {
    for item in items {

      if let image = item.images.first {
        ImageCacheService.shared.storeImage(for: image)
      }
    }
  }
}
