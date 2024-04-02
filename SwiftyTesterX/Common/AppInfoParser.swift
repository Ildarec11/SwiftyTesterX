//
//  AppInfoParser.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Foundation

final class AppsParser {
    
    func parseAvailableApps(_ input: String) -> [App] {
        var apps = [App]()
        
        var lines = input.components(separatedBy: .newlines)
        lines.removeFirst()
        lines.removeLast()
        
        var index = 0
        for line in lines {
            guard line.contains("ApplicationType") && line.contains("User") else {
                index += 1
                continue
            }

            var name = lines[index+3]
            name.removeFirst(30)
            name.removeLast()
            var bundleIdentifier = lines[index + 5]
            bundleIdentifier.removeFirst(30)
            bundleIdentifier.removeLast(2)
            apps.append(App(name: name, bundleIdentifier: bundleIdentifier))
            index += 1
        }
        
        return apps
    }
}
