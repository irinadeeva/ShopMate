typealias ItemsCompletion = (Result<[Item], Error>) -> Void

protocol ItemServiceProtocol {
  func fetchItems(for offset: Int, searchText: String, priceMax: Int?, categoryId: Int?, completion: @escaping ItemsCompletion)
  func fetchItem(for id: Int) -> Item?
}

final class ItemService {
  static let shared = ItemService()
  private let networkClient = DefaultNetworkClient()
  private let storage = ItemsStorage()

  private init() {}
}

extension ItemService: ItemServiceProtocol {
  func fetchItems(for offset: Int, searchText: String, priceMax: Int?, categoryId: Int?, completion: @escaping ItemsCompletion) {
    let request = ItemRequest(offset: offset, searchText: searchText, priceMax: priceMax, categoryId: categoryId)

    networkClient.send(request: request, type: [Item].self) { result in
      switch result {
      case .success(let data):
        self.storage.saveLoadedItems(data)
        let items = self.storage.getLoadedItems()
        completion(.success(items))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func fetchItem(for id: Int) -> Item? {
    storage.getItem(with: id)
  }
}
