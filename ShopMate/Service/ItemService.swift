//
//  Untitled.swift
//  ShopMate
//
//  Created by Irina Deeva on 11/02/25.
//

typealias ItemsCompletion = (Result<[Item], Error>) -> Void

protocol ItemServiceProtocol {
  func fetchItems(completion: @escaping ItemsCompletion)
}

final class ItemService {
  static let shared = ItemService()
  private let networkClient = DefaultNetworkClient()
  private let storage = ItemsStorage()

  private init() {}
}

extension ItemService: ItemServiceProtocol {
  func fetchItems(completion: @escaping ItemsCompletion) {
    print("func fetchItems ")
    let request = ItemRequest()

    networkClient.send(request: request, type: [Item].self) { result in
      switch result {
      case .success(let response):
        print(response)
//        self.storage.items = response
//        completion(response.items)
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
}
