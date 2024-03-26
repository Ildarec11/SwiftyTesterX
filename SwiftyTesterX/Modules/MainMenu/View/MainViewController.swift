//
//  MainViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa
import SnapKit

protocol MainViewControllerOutput: AnyObject {

    func recordButtonDidPressed()
}

protocol MainViewControllerInput: AnyObject {}

final class MainViewController: NSViewController {
    
    weak var output: MainViewControllerOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecordButton()
        setupLabel()
    }
    
    private func setupLabel() {
        let label = NSTextField(labelWithString: "SwiftTesterX")
        label.font = NSFont.systemFont(ofSize: 36)
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupRecordButton() {
        let button = NSButton(title: "Record", target: self, action: #selector(recordButtonDidPressed))
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}

extension MainViewController: MainViewControllerOutput {
    
    @objc func recordButtonDidPressed() {
        output?.recordButtonDidPressed()
    }
}
