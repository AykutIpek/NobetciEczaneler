//
//  UIScreen+Size.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 20.08.2024.
//

import Foundation
import UIKit


extension UIScreen {
    public func sizeCheck(_ type: GFDeviceHeightType) -> Bool {
        let height = bounds.size.height
        return type.rawValue < height
    }
    public func widthCheck(_ type: GFDeviceWidthType) -> Bool {
        let width = bounds.size.width
        return type.rawValue < width
    }
    public enum GFDeviceHeightType: CGFloat {
        case iphone5 = 568 // iPhone 5, iPhone SE 1st Gen
        case iphone6 = 667 // iPhone SE (2nd & 3rd), iPhone 6
        case iphone6Plus = 736 // iPhone 6+
        case iphoneX = 812 // iPhone X, iPhone XS
        case iphoneMax = 896 // iPhone XR, iPhone XS Max
    }
    public enum GFDeviceWidthType: CGFloat {
        case iphone5 = 320 // iPhone 5, iPhone SE 1st Gen
        case iphone6 = 375 // iPhone SE (2nd & 3rd), iPhone 6 to iPhone XS
        case iphone12 = 390 // iPhone 12 to iphone 14
        case iphone14Pro = 393 // iPhone 14 Pro
        case iphonePlus = 414 // iPhone 6/7/8 Plus, XR, 11, XSMax, 11 Pro Max
    }
}
