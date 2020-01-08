//
//  UILabel+Ex.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit


extension UILabel {
    
    /// rich text setting
    ///
    /// - Parameters:
    ///   - subString: str
    ///   - color: color
    ///   - font: font
    ///   - isUnderline: has or not underline
    ///   - isObliqueness: is or not Obliqueness
    public func attributedString(_ subString:String,color:UIColor,font:UIFont,isUnderline:Bool = false,isObliqueness:Bool = false) {
        guard  let text = self.text else{ debugPrint("字符串不能为空"); return}
        let subStrs = text.components(separatedBy: subString)
        var rangs = [NSRange]()
        for i in  0..<subStrs.count{
            var loc:Int = subStrs[i].count
            for j in 0..<i {
                loc = loc + subStrs[j].count + subString.count
            }
            let rang = NSMakeRange(loc, subString.count)
            
            rangs.append(rang)
        }
        
        var dic:[NSAttributedString.Key:Any] = [:]
        if isUnderline {
            if isObliqueness {
                dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.underlineStyle:NSNumber(value: 1),NSAttributedString.Key.obliqueness:0.7]
            }else {
                dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.underlineStyle:NSNumber(value: 1)]
            }
        }else {
            if isObliqueness {
                dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.obliqueness:0.7]
            }else {
                dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color]
            }
        }
        
        var attributedString  =  NSMutableAttributedString(string:self.text!)
        if self.attributedText != nil {
            attributedString  = NSMutableAttributedString(attributedString: self.attributedText!)
        }
        for rang in rangs {
            if attributedString.length >= rang.location + rang.length{
                attributedString.addAttributes(dic, range: rang)
                self.attributedText = attributedString
            }
        }
    }
    
    /// add Strikethrough
    ///
    /// - Parameter lineColor:color of Strikethrough
    public func addDeleteLine(_ lineColor: UIColor = UIColor.lightGray) {
        guard let text = self.text else {return}
        let length = text.count
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, length))
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: lineColor, range: NSRange(location:0,length:length))
        self.attributedText = attributedString
    }
}
