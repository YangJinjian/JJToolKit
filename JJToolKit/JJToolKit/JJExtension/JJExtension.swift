//
//  JJExtension.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/11.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

extension UIImage {
    // 根据颜色生成Image
    class func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        UIGraphicsEndImageContext()
        return nil
    }
}

extension UIColor {
    // 根据HEX值生成UIColor
    class func colorWithHexString(_ hex: String) -> UIColor {
        return colorWithHexString(hex, alpha: 1)
    }
    class func colorWithHexString(_ hex: String, alpha: CGFloat) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = String(cString.suffix(from: index))
        }
        if cString.count != 6 {
            print("Hex string is wrong!")
            return UIColor.red
        }
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString.prefix(upTo: rIndex))
        let otherString = String(cString.suffix(from: rIndex))
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = String(otherString.prefix(upTo: gIndex))
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = String(cString.suffix(from: bIndex))
        var red: CUnsignedInt = 0, green: CUnsignedInt = 0, blue: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&red)
        Scanner(string: gString).scanHexInt32(&green)
        Scanner(string: bString).scanHexInt32(&blue)
        return UIColor(red: CGFloat(red)/255.0,
                       green: CGFloat(green)/255.0,
                       blue: CGFloat(blue)/255.0,
                       alpha: alpha)
    }
    // RGB为相同数值时生成UIColor
    class func colorWithSameValue(_ value: CGFloat) -> UIColor {
        return UIColor(red: value/255.0, green: value/255.0, blue: value/255.0, alpha: 1)
    }
}

extension UIAlertController {
    // 只用作提示的Alert
    class func normalAlert(title: String, message: String, btnTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}

extension Int {
    // arc4random_uniform返回一个0到上界（不含上界）的整数
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
