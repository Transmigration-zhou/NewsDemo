//
//  UIView+Extension.swift
//  NewsDemo
//
//  Created by ByteDance on 2022/5/6.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x = newVal
            frame = tmpFrame
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y = newVal
            frame = tmpFrame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height = newVal
            frame = tmpFrame
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width = newVal
            frame = tmpFrame
        }
    }
    
    var left: CGFloat {
        get {
            return x
        }
        
        set(newVal) {
            x = newVal
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        
        set(newVal) {
            x = newVal - width
        }
    }
    
    var top: CGFloat {
        get {
            return y
        }
        
        set(newVal) {
            y = newVal
        }
    }
    
    var bottom: CGFloat {
        get {
            return y + height
        }
        
        set(newVal) {
            y = newVal - height
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    var middleX: CGFloat {
        get {
            return width / 2
        }
    }
    
    var middleY: CGFloat {
        get {
            return height / 2
        }
    }
    
    var middlePoint: CGPoint {
        get {
            return CGPoint(x: middleX, y: middleY)
        }
    }
}
