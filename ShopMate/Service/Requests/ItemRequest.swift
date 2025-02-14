import Foundation

struct ItemRequest: NetworkRequest {
  var dto: Data?
  
  var httpMethod: HttpMethod { .get }
  
  var endpoint = "\(RequestConstants.baseURL)/api/v1/products"
  
  var queryItems: [URLQueryItem] {
    [URLQueryItem(name: "offset", value: String(offset)),
     URLQueryItem(name: "limit", value: String(10))]
  }
  
  let offset: Int
}
