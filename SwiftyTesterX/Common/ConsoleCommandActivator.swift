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

        process.waitUntilExit()
    }
    
    func showSimulator() {
        let workspace = NSWorkspace.shared
        let simulatorAppURL = URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app")

        do {
            try workspace.open(simulatorAppURL)
        } catch {
            print("Simulator show failed: \(error.localizedDescription)")
        }
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
    
    func startApp(bundleID: String) {
        let process = Process()
        
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "launch", "booted", bundleID]
        process.standardOutput = Pipe()

        process.launch()

        let pipe = process.standardOutput as! Pipe
        let data = pipe.fileHandleForReading.readDataToEndOfFile()

        process.waitUntilExit()
    }
    
    func startCollectingLogs() {
        
    }
}
