//
//  ResultSummarySideBarViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 20.04.2024.
//

import Cocoa
import SnapKit

class ResultSummarySideBarViewController: NSViewController {
    
    weak var output: ResultSummaryViewOutput?

    private let toggleButton = NSSwitch()
    private let toggleLabel = NSTextField(labelWithString: "Swipe (Off) / Pan (On)")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToggleSwitch()
    }
    
    private func setupToggleSwitch() {
        toggleButton.frame = NSRect(x: 20, y: 20, width: 50, height: 30)
        toggleButton.target = self
        toggleButton.action = #selector(toggleChanged(_:))
        
        toggleLabel.frame = NSRect(x: 80, y: 15, width: 200, height: 30)
        view.addSubview(toggleLabel)
        view.addSubview(toggleButton)
    }
    
    @objc func toggleChanged(_ sender: NSSwitch) {
        output?.viewDidToggleGestureSelect(isPanSelected: sender.state == .on)
    }
}
