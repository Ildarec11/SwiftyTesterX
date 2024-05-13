//
//  SimulatorLogCollector.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 04.04.2024.
//

import Foundation

protocol SimulatorLogDelegate: AnyObject {
    
    func didReceiveValue(_ value: String)
}

final class SimulatorLogCollector {
    
    private weak var delegate: SimulatorLogDelegate?

    init(delegate: SimulatorLogDelegate) {
        self.delegate = delegate
    }
    
    func runSimulatorLogStreaming() {
        let task = Process()
        task.launchPath = "/usr/bin/xcrun"
        task.arguments = ["simctl", "spawn", "booted", "log", "stream", "-predicate", "eventMessage contains 'SwiftyTester:=>'"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let file = pipe.fileHandleForReading
        file.waitForDataInBackgroundAndNotify()
        
        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: file, queue: nil) { [weak self] notification in
            let data = file.availableData
            if data.count > 0 {
                if let output = String(data: data, encoding: .utf8) {
                    self?.delegate?.didReceiveValue(output)
                }
                file.waitForDataInBackgroundAndNotify()
            }
        }
        
        // task.waitUntilExit()
    }
}
