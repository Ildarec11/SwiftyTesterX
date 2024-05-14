//
//  UIWindow+Extensions.swift
//  SwiftyTesterLib
//
//  Created by Ильдар Арсламбеков on 14.04.2024.
//

import Foundation

extension UIWindow {
    
    private static var lastTouchLocation: CGPoint = .zero

    static var lastTouchPoint: CGPoint {
        get {
            return lastTouchLocation
        }
        set {
            lastTouchLocation = newValue
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let touchPoint = touch.location(in: self)
            UIWindow.lastTouchPoint = touchPoint
        }
    }
}
