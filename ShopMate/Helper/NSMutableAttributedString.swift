import UIKit

extension NSMutableAttributedString {
    public func setBold(text: String) {
        let foundRange = mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor { traits in
                    return traits.userInterfaceStyle == .dark
                    ? .white
                    : .black
                },
                range: foundRange
            )
        }
    }
}
