//
//  ConsoleCommandActivator.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

final class ConsoleCommandActivator {

    func listSimulatorDevices() -> String? {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "list", "devices"]
        process.standardOutput = Pipe()

        process.launch()

        let pipe = process.standardOutput as! Pipe
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        }

        process.waitUntilExit()
        return nil
    }
    
    func bootSimulator(deviceUUID: String) {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "boot", deviceUUID]
        process.standardOutput = Pipe()

        process.launch()
        let pipe = process.standardOutput as! Pipe
        // let data = pipe.fileHandleForReading.readDataToEndOfFile()

        process.waitUntilExit()
    }
    
    func appsList(deviceUUID: String) -> String? {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "listapps", deviceUUID]
        process.standardOutput = Pipe()

        process.launch()

        let pipe = process.standardOutput as! Pipe
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        }

        process.waitUntilExit()
        return nil
    }
}
