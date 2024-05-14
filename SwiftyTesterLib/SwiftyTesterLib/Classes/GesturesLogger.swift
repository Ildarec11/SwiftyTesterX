//
//  GesturesLogger.swift
//  SwiftyTesterLib
//
//  Created by Ильдар Арсламбеков on 30.03.2024.
//

import Foundation
import UIKit
import os

final class GesturesLogger {
    
    static let shared = GesturesLogger()
    
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SwiftyTester")
    
    func log(gesture: UIGestureRecognizer) {
        let converter = GestureToStringConverter()
        let message = converter.gestureToString(gesture)
        os_log("%{public}@", log: logger, type: .default, message)
    }
    
    func log(url: String, body: [String: Any]) {
        let converter = GestureToStringConverter()
        let message = converter.requestToString(url: url, body: body)
        os_log("%{public}@", log: logger, type: .default, message)
    }
}
