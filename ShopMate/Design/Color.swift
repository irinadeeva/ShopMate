import UIKit

extension UIColor {
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let alpha, red, green, blue: UInt64
    
    switch hex.count {
    case 3: // RGB (12-bit)
      (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (alpha, red, green, blue) = (255, 0, 0, 0)
    }
    
    self.init(
      red: CGFloat(red) / 255,
      green: CGFloat(green) / 255,
      blue: CGFloat(blue) / 255,
      alpha: CGFloat(alpha) / 255
    )
  }
  
  private static let customBlackLight = UIColor(hexString: "1A1B22")
  private static let customBlackDark = UIColor.white
  private static let customGreenLight = UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1)
  private static let customGreenDark = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1)
  
  static let background = UIColor { traits in
    return traits.userInterfaceStyle == .dark
    ? .customBlackLight
    : .customBlackDark
  }
  
  static let textColor = UIColor { traits in
    return traits.userInterfaceStyle == .dark
    ? .customBlackDark
    : .customBlackLight
  }
  
  static let greenTextColor = UIColor { traits in
    return traits.userInterfaceStyle == .dark
    ? .customBlackDark
    : .customBlackLight
  }
}
