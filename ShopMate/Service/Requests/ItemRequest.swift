import Foundation

struct ItemRequest: NetworkRequest {
  var dto: Data?
  
  var httpMethod: HttpMethod { .get }
  
  var endpoint = "\(RequestConstants.baseURL)/api/v1/products"
  
  var queryItems: [URLQueryItem] {
    var items: [URLQueryItem] = [
      URLQueryItem(name: "offset", value: String(offset)),
      URLQueryItem(name: "limit", value: String(10))
    ]

    if let priceMax = priceMax {
      items.append(URLQueryItem(name: "price_min", value: String(0)))
      items.append(URLQueryItem(name: "price_max", value: String(priceMax)))
    }

    if let categoryId = categoryId {
      items.append(URLQueryItem(name: "categoryId", value: String(categoryId)))
    }

    if !searchText.isEmpty {
      items.append(URLQueryItem(name: "title", value: searchText))
    }

    return items
  }
  
  let offset: Int

  let searchText: String

  let priceMax: Int?

  let categoryId: Int?
}
