typealias CategoryCompletion = (Result<[Category], Error>) -> Void

protocol CategoryServiceProtocol {
  func fetchCategory(completion: @escaping CategoryCompletion)
}

final class CategoryService {
  static let shared = CategoryService()
  private let networkClient = DefaultNetworkClient()
  private var storage: [Category] = []

  private init() {}
}

extension CategoryService: CategoryServiceProtocol {
  func fetchCategory(completion: @escaping CategoryCompletion) {
    let request = CategoryRequest()

    if !storage.isEmpty {
      completion(.success(storage))
      return
    }

    networkClient.send(request: request, type: [Category].self) { result in
      switch result {
      case .success(let data):
        let cleanedData = self.cleanData(data)
        self.storage = cleanedData
        completion(.success(cleanedData))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func cleanData(_ data: [Category]) -> [Category] {
    var uniqueCategories: [Category] = []

    for category in data {
        if !uniqueCategories.contains(where: { $0.name == category.name }) {
            uniqueCategories.append(category)
        }
    }

    return uniqueCategories
  }
}
