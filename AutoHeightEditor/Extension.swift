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
