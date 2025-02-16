import Foundation

struct Item: Codable, Identifiable, Hashable {
  let id: Int
  let title: String
  let price: Int
  let description: String
  var images: [String]
  let category: Category

  static func cleanImages(_ images: [String]) -> [String] {
      return images.map {
          $0.replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "\\", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
      }
  }
}
