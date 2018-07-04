//
//  UIColor+Extensions.swift
//  NCDemo
//
//  Created by Vivek Gupta on 29/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation

extension UIColor {
    class func hexStringToUIColor (hex: String) -> UIColor {
        let cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        
        let scanner = Scanner(string: cString)
        if (cString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        scanner.scanHexInt32(&rgbValue)
        
        return UIColor.RGBAColor(CGFloat((rgbValue & 0xFF0000) >> 16), green: CGFloat((rgbValue & 0x00FF00) >> 8), blue: CGFloat(rgbValue & 0x0000FF), alpha: CGFloat(1.0))
        
    }
    class func RGBAColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
