//
//  UIColor+Ex.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Hex String -> UIColor
    /// - Parameter hexString: color`s hexString`
    convenience init(hexString: String,alpha:CGFloat = 1) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    convenience init(_ red:Int,_ green:Int,_ blue:Int,_ alpha:CGFloat = 1) {
        let r  = CGFloat(red) / 255.0
        let g = CGFloat(red) / 255.0
        let b = CGFloat(red) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
