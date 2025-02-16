import Foundation

protocol SearchHistoryServiceProtocol {
  func getSearchHistory() -> [String]
}

final class SearchHistoryService {
  static let shared = SearchHistoryService()
  private var searchHistory: [String] = [] {
      didSet {
          if searchHistory.count > 5 {
              searchHistory.removeFirst()
          }
      }
  }

  private init() {}
}

extension SearchHistoryService: SearchHistoryServiceProtocol  {
  func getSearchHistory() -> [String] {
    return searchHistory
  }
  
  func appendSearchHistory(_ searchText: String) {
    if !searchHistory.contains(searchText) {
      searchHistory.append(searchText)
    }
  }
}
