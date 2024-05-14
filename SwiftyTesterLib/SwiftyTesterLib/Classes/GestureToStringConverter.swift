//
//  GestureToStringConverter.swift
//  SwiftyTesterLib
//
//  Created by Ильдар Арсламбеков on 30.03.2024.
//

import UIKit
import Foundation

final class GestureToStringConverter {
    
    private let prefix = "SwiftyTester:=>"
    
    func requestToString(url: String, body: [String: Any]) -> String {
        return prefix + "Request|\(url)|\(body)" + "<=:SwiftyTester"
    }
    
    func gestureToString(_ gesture: UIGestureRecognizer) -> String {
        var resultString = prefix
        let typeString: String
        if gesture is UITapGestureRecognizer {
            typeString = "TapGesture"
        } else if let swipe = gesture as? UISwipeGestureRecognizer {
            let directionString: String
            switch swipe.direction {
            case .down:
                directionString = "Down"
            case .left:
                directionString = "Left"
            case .right:
                directionString = "Right"
            case .up:
                directionString = "Up"
            default:
                directionString = "Defalt"
            }
            typeString = "Swipe|\(directionString)"
            
        } else if let pan = gesture as? UIPanGestureRecognizer {
            var gestureState: String
            switch pan.state {
            case .began:
                gestureState = "began"
            case .changed:
                gestureState = "changed"
            case .ended:
                gestureState = "ended"
            default:
                gestureState = "unknown"
            }
            typeString = "Pan|\(gestureState)"
        } else {
            typeString = "unknown"
        }
        resultString.append(typeString)
        if let viewInfoText = getInfoFromViewInGesture(gesture: gesture) {
            resultString.append(viewInfoText)
        }
        return resultString
    }
    
    private func getInfoFromViewInGesture(gesture: UIGestureRecognizer) -> String? {
        guard let view = getViewByCoordinates(gesture: gesture) else { return nil }
        var resultString = ""
        if let cooridnates = getLocationFromGesture(gesture: gesture) {
            resultString.append("|location:(\(cooridnates.x), \(cooridnates.y))")
        }
        if let accessibilityIdentifier = view.accessibilityIdentifier {
            resultString.append("|accessibilityIdentifier:\(accessibilityIdentifier)")
        }
        if let label = view as? UILabel, let labelText = label.text {
            resultString.append("|text:\(labelText)")
        } else if let button = view as? UIButton, let buttonText = button.titleLabel?.text {
            resultString.append("|text:\(buttonText)")
        }
        resultString.append("|hash:\(view.hash)")
        
        resultString.append("<=:SwiftyTester")
        return resultString
    }
    
    private func getViewByCoordinates(gesture: UIGestureRecognizer) -> UIView? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        
        let point = getLocationFromGesture(gesture: gesture)
        
        guard let point else { return nil }

        if let view = window.hitTest(point, with: nil) {
            return view
        } else {
            return nil
        }
    }
    
    private func getLocationFromGesture(gesture: UIGestureRecognizer) -> CGPoint? {
        if let tap = gesture as? UITapGestureRecognizer {
            return gesture.location(in: nil)
        } else if gesture is UISwipeGestureRecognizer {
            return UIWindow.lastTouchPoint
        } else if let pan = gesture as? UIPanGestureRecognizer {
            return pan.location(in: nil)
        } else {
            return nil
        }
    }
}
