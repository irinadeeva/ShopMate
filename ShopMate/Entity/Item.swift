import Foundation

struct Item: Codable, Identifiable, Hashable {
  let id: Int
  let title: String
  let price: Int
  let description: String
  var images: [String]
  let category: Category
}
