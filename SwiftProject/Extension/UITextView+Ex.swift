//
//  UITextView+Ex.swift
//  DoNewSeas
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit

extension UITextView {
    /// 添加富文本可点击 or 无点击
    /// - Parameters:
    ///   - totalString: 总的字符串
    ///   - subString: 特殊变化的字符串
    ///   - originColor: 原始color
    ///   - specialColor: 特殊color
    ///   - originFont: 原始font
    ///   - specialFont: 特殊font
    ///   - txtAligment: 文本Alignment
    ///   - link: 点击的scheme
    ///   - haveBottomLine: 是否有下划线
    ///   - canClick: 是否可点击
    ///   - textViewDelegate: 系统代理
    public func attributedTouchedString(_ totalString: NSString,
                                        subString: String = "",
                                        originColor: UIColor,
                                        specialColor: UIColor?,
                                        originFont: UIFont,
                                        specialFont: UIFont?,
                                        txtAligment: NSTextAlignment,
                                        link: String,
                                        haveBottomLine: Bool = false,
                                        canClick: Bool = false,
                                        textViewDelegate: UITextViewDelegate?) {
      
        self.font = originFont
        let specialFont = specialFont == nil ? originFont : specialFont
        let specialColor = specialColor == nil ? originColor : specialColor

        let attrMsg : NSMutableAttributedString = NSMutableAttributedString(string:totalString as String)
        let range = totalString.range(of: subString)
        if canClick,textViewDelegate != nil {
            attrMsg.addAttribute(NSAttributedString.Key.link, value: "\(link)://", range:  range)
        }
        attrMsg.addAttribute(NSAttributedString.Key.foregroundColor, value:originColor, range:NSMakeRange(0, totalString.length))
        
       
        self.linkTextAttributes = [:]
        attrMsg.addAttribute(NSAttributedString.Key.foregroundColor, value:specialColor!, range:range)
        if haveBottomLine {
            attrMsg.addAttributes([NSAttributedString.Key.underlineStyle: 1], range: range)
        }
        attrMsg.addAttribute(NSAttributedString.Key.font, value:specialFont!, range:range)
        self.attributedText = attrMsg
        self.textAlignment = txtAligment
        self.isScrollEnabled = false
        self.isEditable = false
        guard textViewDelegate != nil else {
            return
        }
        self.delegate = textViewDelegate
    }
}
