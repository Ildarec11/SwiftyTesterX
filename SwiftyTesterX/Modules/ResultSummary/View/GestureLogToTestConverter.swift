//
//  GestureLogToTestConverter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 05.04.2024.
//

import Foundation

protocol GestureLogToTestConverterDelegate: AnyObject {
    func askInterpolationPointsCount(closure: @escaping (Int) -> Void)
}

final class GestureLogToTestConverter {
    
    weak var delegate: GestureLogToTestConverterDelegate?
    
    var isPanGesturePrefered = false
    
    var lastPanGesture: [CGPoint] = []

    private var currentLineIndex = 15
    private var currentTestString =
    """
    //
    //  SwiftyTesterUITests.swift
    //  SwiftyTesterUITests
    //
    //  Created by SwiftyTesterX on 05.04.2024.
    //

    import XCTest

    final class SwiftyTesterUITests: XCTestCase {


        func testExample() throws {
            let app = XCUIApplication()
            app.launch()
    
        }
    }
    """
    
    init(delegate: GestureLogToTestConverterDelegate) {
        self.delegate = delegate
    }
    
    func getCurrentTestString() -> String {
        return currentTestString
    }
    
    func addLogValueToTest(_ value: String) {
        let extractedGestureInfo = extractGestureInfo(inputString: value)
        guard let info = extractedGestureInfo else {
            print("-- extracted nil")
            return
        }
        
        guard let type = extractGestureType(inputString: info) else {
            print("-- Failed: can'g get gesture type")
            return
        }
        switch type {
        case .tap:
            appendNewValueForTapGesture(info: info)
        case .swipe(let direction):
            if !isPanGesturePrefered {
                appendNewValueForSwipeGesture(direction: direction, info: info)
            }
        case .pan(let type):
            if isPanGesturePrefered {
                appendNewValueForPanGesture(info: info, type: type)
            }
        }
    }
    
    private func appendNewValueForPanGesture(info: String, type: GestureType.PanType) {
        let location = extractLocation(gestureInfo: info)
        guard let location else { return }
        if type == .began {
            lastPanGesture = []
        }
        lastPanGesture.append(location)
        if type == .ended {
            delegate?.askInterpolationPointsCount(closure: { count in
                print("-- count \(count)")
            })
        }
    }
    
    private func appendNewValueForSwipeGesture(direction: GestureType.SwipeDirection, info: String) {
        let actionString: String
        switch direction {
        case .up:
            actionString = "swipeUp()"
        case .down:
            actionString = "swipeDown()"
        case .left:
            actionString = "swipeLeft()"
        case .right:
            actionString = "swipeRight()"
        }
        if let accessibilityIdentifier = extractAccessibilityIdentifier(gestureInfo: info) {
            print("-- accessibilityIdentifier \(accessibilityIdentifier)")
            appendNewValueToCurrentTestString("app.otherElements[\"\(accessibilityIdentifier)\"].\(actionString)")
        } else if let text = extractText(gestureInfo: info) {
            print("-- text \(text)")
            appendNewValueToCurrentTestString("app.staticTexts[\"\(text)\"].\(actionString)")
        } else if let location = extractLocation(gestureInfo: info) {
            print("-- location \(location)")
            appendNewValueToCurrentTestString("app.coordinate(withNormalizedOffset: .zero).withOffset(CGVector(dx: \(location.x), dy: \(location.y)).\(actionString)")
        }
    }
    
    private func appendNewValueForTapGesture(info: String) {
        if let accessibilityIdentifier = extractAccessibilityIdentifier(gestureInfo: info) {
            print("-- accessibilityIdentifier \(accessibilityIdentifier)")
            appendNewValueToCurrentTestString("app.otherElements[\"\(accessibilityIdentifier)\"].tap()")
        } else if let text = extractText(gestureInfo: info) {
            print("-- text \(text)")
            appendNewValueToCurrentTestString("app.staticTexts[\"\(text)\"].tap()")
        } else if let location = extractLocation(gestureInfo: info) {
            print("-- location \(location)")
            appendNewValueToCurrentTestString("app.coordinate(withNormalizedOffset: .zero).withOffset(CGVector(dx: \(location.x), dy: \(location.y)).tap()")
        }
    }
    
    private func appendNewValueToCurrentTestString(_ value: String) {
        var stringArr = currentTestString.components(separatedBy: .newlines)
        let resultString = "        \(value)"
        stringArr.insert(resultString, at: currentLineIndex)
        currentTestString = stringArr.joined(separator: "\n")
        currentLineIndex += 1
    }
    
    private func extractGestureInfo(inputString: String) -> String? {
        let pattern = "SwiftyTester:=>(.*?)<=:SwiftyTester"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = inputString as NSString
            if let match = regex.firstMatch(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length)) {
                let range = match.range(at: 1)
                if range.location != NSNotFound {
                    let extractedString = nsString.substring(with: range)
                    return extractedString
                }
            }
        }
        return nil
    }
    
    private func extractGestureType(inputString: String) -> GestureType? {
        let arr = inputString.components(separatedBy: "|")
        guard let type = arr.first else { return nil }
        print("-- type :\(type)")
        if type.starts(with: "TapGesture") {
            return .tap
        } else if type.starts(with: "Swipe") {
            guard let direction = extractDirection(direction: arr[1]) else { return nil }
            return .swipe(direction: direction)
        } else if type.starts(with: "Pan") {
            guard let status = extractPanStatus(status: arr[1]) else { return nil }
            return .pan(type: status)
        }
        return nil
    }
    
    private func extractPanStatus(status: String) -> GestureType.PanType? {
        if status == "began" {
            return .began
        } else if status == "changed" {
            return .changed
        } else if status == "ended" {
            return .ended
        } else {
            return nil
        }
    }
    
    private func extractDirection(direction: String) -> GestureType.SwipeDirection? {
        if direction == "Left" {
            return .left
        } else if direction == "Right" {
            return .right
        } else if direction == "Up" {
            return .up
        } else if direction == "Down" {
            return .down
        }
        return nil
    }
    
    private func extractLocation(gestureInfo: String) -> CGPoint? {
        let arr = gestureInfo.components(separatedBy: "|")
        let element = arr.first(where: {
            $0.contains("location:")
        })
        guard var element else { return nil }
        element.removeFirst(9)
        guard element != "nil" else { return nil }
        
        let cleanedString = element.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

        let components = cleanedString.components(separatedBy: ", ")
        if components.count == 2, let x = Double(components[0]), let y = Double(components[1]) {
            let point = CGPoint(x: x, y: y)
            print("-- location exist")
            return point
        } else {
            print("-- location nil")
            return nil
        }
    }
    
    private func extractAccessibilityIdentifier(gestureInfo: String) -> String? {
        let arr = gestureInfo.components(separatedBy: "|")
        let element = arr.first(where: {
            $0.contains("accessibilityIdentifier:")
        })
        guard var element else { return nil }
        element.removeFirst(24)
        guard element != "nil" else { return nil }
        return element
    }
    
    private func extractText(gestureInfo: String) -> String? {
        let arr = gestureInfo.components(separatedBy: "|")
        let element = arr.first(where: {
            $0.contains("text:")
        })
        guard var element else { return nil }
        guard element != "nil" else { return nil }
        element.removeFirst(5)
        return element
    }
}
