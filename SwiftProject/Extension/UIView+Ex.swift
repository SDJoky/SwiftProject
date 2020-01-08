//
//  UIView+Ex.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit

extension UIView {
    /// Add border,include color add width
    /// - Parameter color: color of border
    /// - Parameter width: width of border
    public func border(_ color:UIColor,width:CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    public func borderWidth(_ width:CGFloat)
    {
        self.layer.borderWidth = width
    }
    public func borderColor(_ color:UIColor)
    {
        self.layer.borderColor = color.cgColor
    }
    
    
    
    /// Add corner
    /// - Parameter radius: value of radius
    public func cornerRadius(_ radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    
    /// 给UIView对象设置虚线边框
    /// - Parameters:
    ///   - rect: 控件大小
    ///   - strokeColor: 虚线的颜色
    ///   - radius: 控件的圆角
    ///   - lineWidth: 虚线的高度
    ///   - lineSpace: 数组：虚线之间的间距
    public func addDashedLine(_ rect: CGRect,
                              strokeColor: UIColor,
                              radius: CGFloat,
                              lineWidth: CGFloat,
                              lineSpace: [NSNumber]) {
       let border =  CAShapeLayer()
        border.strokeColor = strokeColor.cgColor
        border.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        border.path = path.cgPath
        border.frame = rect
        border.lineWidth = lineWidth
        border.lineDashPattern = lineSpace
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.addSublayer(border)
    }
    
    public var x:CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y:CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    
    public var centerX:CGFloat {
        get { return self.center.x }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get { return self.center.y }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
}
