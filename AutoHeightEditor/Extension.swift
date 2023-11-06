import SwiftUI

extension CGFloat {
    var asInt: Int {
        switch self {
        case .infinity, .nan:
            return 0
        default:
            return Int(self)
        }
    }
}

extension Int {
    var asFloat: CGFloat {
        return CGFloat(self)
    }
}

extension UIFont {
    // MARK: Method - SwiftUI system Font를 UIFont 타입으로 변환하는 함수
    static func fontToUIFont(from font: Font) -> UIFont {
        let style: UIFont.TextStyle
        
        switch font {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body:        style = .body
        default:           style = .body
        }
        
        return  UIFont.preferredFont(forTextStyle: style)
    }
}
