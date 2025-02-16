import Foundation

protocol ImageCacheServiceProtocol {
  func storeImage(for url: String)
  func getImage(for url: String) -> Data?
}

final class ImageCacheService {
  private let imageCache = NSCache<NSString, NSData>()
  static let shared = ImageCacheService()
  //TODO: вынести
  //  private let storage = ImageCacheStorage()
  
  private init() {}
}

extension ImageCacheService: ImageCacheServiceProtocol {
  func storeImage(for url: String) {
    guard imageCache.object(forKey: url as NSString) == nil,
          let imageURL = URL(string: url) else { return }
    
    DispatchQueue.global().async {
      if let imageData = try? Data(contentsOf: imageURL) {
        self.imageCache.setObject(imageData as NSData, forKey: url as NSString)
      }
    }
  }
  
  func getImage(for url: String) -> Data? {
    return imageCache.object(forKey: url as NSString) as Data?
  }
}
