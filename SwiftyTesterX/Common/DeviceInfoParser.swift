//
//  DeviceInfoParser.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Foundation

final class DeviceInfoParser {
    
    func parseDevicesInfo(_ input: String) -> [Device] {
        var devices = [Device]()
        
        var lines = input.components(separatedBy: .newlines)
        lines.removeFirst()
        lines.removeLast()
        var currentOS = ""
        for line in lines {
            guard line.starts(with: "--") else {
                if let device = parseDevice(line: line, currentOS: currentOS) {
                    devices.append(device)
                }
                continue
            }
            var os = line
            os.removeFirst(3)
            os.removeLast(3)
            currentOS = os
        }
        
        return devices
    }
    
    private func parseDevice(line: String, currentOS: String) -> Device? {
        var fieldsLine = line
        fieldsLine.removeFirst(4)
        let regex = try! NSRegularExpression(pattern: "([0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12})")
        
        
        if let match = regex.firstMatch(in: fieldsLine, options: [], range: NSRange(location: 0, length: fieldsLine.utf16.count)) {

            let idRange = Range(match.range(at: 1), in: fieldsLine)!
            let deviceUUID = fieldsLine[idRange]
            
            let cutted = line.components(separatedBy: "(\(deviceUUID))")
            let name = cutted[0]
            let status = cutted[1]
            
            return Device(
                name: name,
                identifier: String(deviceUUID),
                status: status,
                os: currentOS
            )
        } else {
            print("-- Error: Failed to find UUID")
            return nil
        }
    }
}
