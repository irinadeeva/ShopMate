import Foundation

struct CategoryRequest: NetworkRequest {
  var queryItems: [URLQueryItem] = []
  
  var dto: Data?
  
  var httpMethod: HttpMethod { .get }
  
  var endpoint = "\(RequestConstants.baseURL)/api/v1/categories"
}
