//
//  RequestStubGenerator.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 25.05.2024.
//

import Foundation

final class RequestStubGenerator {
    
    func generateStubString(url: String, body: String)  -> String {
        let components = url.components(separatedBy: ".com")
        let host = components[0]
        let path = components[safe: 1]
        var pathCondition = ""
        if let path = path {
            pathCondition = "&& isPath(\"\(path)\")"
        }
        let string = """

        stub(condition: isHost("\(host).com") \(pathCondition)  { _ in
         
          let stubPath = OHPathForFile("http://\(host).com\(path ?? "").json", type(of: self))
          return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
"""
        return string
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
