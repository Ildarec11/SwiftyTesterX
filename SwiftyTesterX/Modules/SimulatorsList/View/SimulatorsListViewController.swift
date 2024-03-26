//
//  SimulatorsListViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

final class SimulatorsListViewController: NSViewController {

    @IBOutlet weak var simulatorsListTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        simulatorsListTableView.delegate  = self
        runConsoleCommand()
    }
    
    private func runConsoleCommand() {
        let task = Process()
        task.launchPath = "/usr/bin/dev"
        task.arguments = ["ls"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print("Output: \(output)")
        }
    }
}


// MARK: NSTableViewDelegate

extension SimulatorsListViewController: NSTableViewDelegate {
    
}
