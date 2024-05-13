//
//  GestureLogToTestConverter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 05.04.2024.
//

import Foundation

protocol GestureLogToTestConverterDelegate: AnyObject {
    func addNewRequestFile(url: String, body: String)
}

final class GestureLogToTestConverter {
    
    weak var delegate: GestureLogToTestConverterDelegate?
    
    var isPanGesturePrefered = false
    
    var lastPanGesture: [CGPoint] = []

    private var currentLineIndex = 16
    
    private var isNormalizeFunctionAdded = false
    private let normalizeFunction =
    """

        func normalizeX(_ absoluteX: Double) -> CGFloat {
            let screenSize = UIScreen.main.bounds
            
            let normalizedX = absoluteX / screenSize.width
            return normalizedX
        }
    
        func normalizeY(_ absoluteY: Double) -> CGFloat {
            let screenSize = UIScreen.main.bounds
            
            let normalizedY = absoluteY / screenSize.height
            return normalizedY
        }
    """
    
    private var currentTestString =
    """
    //
    //  SwiftyTesterUITests.swift
    //  SwiftyTesterUITests
    //
    //  Created by SwiftyTesterX on 05.04.2024.
    //

    import XCTest
    import OHHTTPStub

    final class SwiftyTesterUITests: XCTestCase {

        func testExample() throws {
    
            let app = XCUIApplication()
            app.launch()
    
        }
    }
    """
    
    private func addStubsFuncString(requestString: String) -> String {
        guard requestString != "" else { return "" }
    return """
    
        func addStubs() {
    \(requestString)
        }\n
    """
    }
    
    private var variableNumber = 0
    
    private let requestStringGenerator = RequestStubGenerator()
    private var enabledRequests: [String: String] = [:]
    private var requestString = ""
    
    init(delegate: GestureLogToTestConverterDelegate) {
        self.delegate = delegate
    }
    
    func getCurrentTestString() -> String {
        return currentTestString
    }
    
    func updateEnabledRequests(_ enabledRequests: [String: String]) {
        self.enabledRequests = enabledRequests
        var resultString = ""
        for request in enabledRequests {
            let string = requestStringGenerator.generateStubString(url: request.key, body: request.value)
            resultString.append(string)
        }
        let funcString = addStubsFuncString(requestString: resultString)
        requestString = funcString

        var stringArr = currentTestString.components(separatedBy: .newlines)
        let index = stringArr.firstIndex(where: {
            $0.contains("func addStubs()")
        })
        if let index {
            stringArr.removeLast(stringArr.count - index + 1)
        } else {
            stringArr.removeLast()
        }
        stringArr.append(requestString)
        
        
        let exampleFirstIndex = stringArr.firstIndex(where: {
            $0.contains("testExample()")
        })!
        let addRequestFuncCall = stringArr[exampleFirstIndex+1]
        if addRequestFuncCall.contains("addStubs()") {
            if enabledRequests.isEmpty {
                stringArr.remove(at: exampleFirstIndex+1)
                currentLineIndex = currentLineIndex - 1
            }
        } else {
            if !enabledRequests.isEmpty {
                stringArr.insert("        addStubs()", at: exampleFirstIndex+1)
                currentLineIndex += 1
            }
        }
        
        currentTestString = stringArr.joined(separator: "\n")
        currentTestString.append("}")
    }
    
    func addLogValueToTest(_ value: String) {
        let extractedGestureInfo = extractGestureInfo(inputString: value)
        guard let info = extractedGestureInfo else {
            return
        }
        
        guard let type = extractGestureType(inputString: info) else {
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
        case .request(url: let url, body: let body):
            appendNewValueForRequest(url: url, body: body)
        }
    }
    
    private func appendNewValueForRequest(url: String, body: String) {
        delegate?.addNewRequestFile(url: url, body: body)
    }
    
    private func appendNewValueForPanGesture(info: String, type: GestureType.PanType) {
        let location = extractLocation(gestureInfo: info)
        guard let location else { return }
        if type == .began {
            lastPanGesture = []
        }
        lastPanGesture.append(location)
        if type == .ended {
            let peckeredPoints = douglasPeucker(PointList: lastPanGesture, epsilon: 40)
            if !isNormalizeFunctionAdded {
                appendNormalizeFunctionToCurrentString()
            }
            for i in 0...peckeredPoints.count-2 {
                appendCoordinatesSwipe(startPoint: peckeredPoints[i], endPoint: peckeredPoints[i+1])
            }
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
    
    private func appendCoordinatesSwipe(startPoint: CGPoint, endPoint: CGPoint) {
        let lock = NSLock()
        lock.lock()
        let line =
    """
            let startPoint\(variableNumber) = app.coordinate(withNormalizedOffset: CGVector(dx: normalizeX(\(startPoint.x)), dy: normalizeY(\(startPoint.y)))
            let endPoint\(variableNumber) = app.coordinate(withNormalizedOffset: CGVector(dx: normalizeY(\(endPoint.x)), dy: normalizeY(\(endPoint.y)))
            startPoint\(variableNumber).press(forDuration: 0, thenDragTo: endPoint\(variableNumber))

    """
        appendLinesToCurrentTestString(line)
        variableNumber = variableNumber + 1
        lock.unlock()
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
    
    private func appendLinesToCurrentTestString(_ value: String) {
        let lock = NSLock()
        lock.lock()

        var stringArr = currentTestString.components(separatedBy: .newlines)
        let valueArr = value.components(separatedBy: .newlines)
        stringArr.insert(contentsOf: valueArr, at: currentLineIndex)
        currentTestString = stringArr.joined(separator: "\n")
        currentLineIndex += valueArr.count
        
        lock.unlock()
    }
    
    private func appendNewValueToCurrentTestString(_ value: String) {
        let lock = NSLock()
        lock.lock()
        var stringArr = currentTestString.components(separatedBy: .newlines)
        let resultString = "        \(value)"
        stringArr.insert(resultString, at: currentLineIndex)
        currentTestString = stringArr.joined(separator: "\n")
        currentLineIndex += 1
        lock.unlock()
    }
    
    private func appendNormalizeFunctionToCurrentString() {
        var stringArr = currentTestString.components(separatedBy: .newlines)
        stringArr.insert(normalizeFunction, at: stringArr.count - 1)
        currentTestString = stringArr.joined(separator: "\n")
        isNormalizeFunctionAdded = true
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
        } else if type.starts(with: "Request") {
            return .request(url: arr[1], body: arr[2])
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
            return point
        } else {
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

func douglasPeucker(PointList: [CGPoint], epsilon: Double) -> [CGPoint] {
    var stack = [(Int, Int)]()
    var keepPoint = [Bool](repeating: true, count: PointList.count)
    var resultList = [CGPoint]()
    
    stack.append((0, PointList.count - 1))
    
    while !stack.isEmpty {
        let (startIndex, endIndex) = stack.removeLast()
        
        var dMax = 0.0
        var index = startIndex
        
        for i in (startIndex + 1)..<endIndex {
            if keepPoint[i] {
                let d = perpendicularDistance(point: PointList[i], line: .init(start: PointList[startIndex], end: PointList[endIndex]))
                if d > dMax {
                    index = i
                    dMax = d
                }
            }
        }
        
        if dMax >= epsilon {
            stack.append((startIndex, index))
            stack.append((index, endIndex))
        } else {
            for j in (startIndex + 1)..<endIndex {
                keepPoint[j] = false
            }
        }
    }
    
    for i in 0..<PointList.count {
        if keepPoint[i] {
            resultList.append(PointList[i])
        }
    }
    
    return resultList
}

struct Line {
    let start: CGPoint
    let end: CGPoint
}

func perpendicularDistance(point: CGPoint, line: Line) -> Double {
    let dx = line.end.x - line.start.x
    let dy = line.end.y - line.start.y
    
    if dx == 0 {
        return abs(point.x - line.start.x)
    }
    
    let slope = dy / dx
    let intercept = line.start.y - slope * line.start.x
        
    let perpendicularSlope = -1 / slope
    let perpendicularIntercept = point.y - perpendicularSlope * point.x
    
    let intersectionX = (perpendicularIntercept - intercept) / (slope - perpendicularSlope)
    let intersectionY = slope * intersectionX + intercept
    
    let distance = sqrt((point.x - intersectionX) * (point.x - intersectionX) + (point.y - intersectionY) * (point.y - intersectionY))
    
    return distance
}

