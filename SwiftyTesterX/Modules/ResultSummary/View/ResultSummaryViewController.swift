//
//  ResultSummaryViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

protocol ResultSummaryViewInput: AnyObject {
    func updateSummaryText(_ text: String)
    func askInterpolationPointsCount(closure: @escaping (Int) -> Void)
}

protocol ResultSummaryViewOutput: AnyObject {
    func viewDidLoad()
    func viewDidToggleGestureSelect(isPanSelected: Bool)
    func copySummaryText(_ text: String)
}

final class ResultSummaryViewController: NSViewController, ResultSummaryViewInput {

    var output: ResultSummaryViewOutput?

    private lazy var summaryTextView: NSTextView = {
        let textView = NSTextView()
        textView.isEditable = true
        
        let font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        textView.font = font
        
        textView.textColor = NSColor.textColor

        return textView
    }()
    
    private lazy var copyButton: NSButton = {
        let button = NSButton(title: "Copy", target: self, action: #selector(copyButtonClicked))
        return button
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = summaryTextView
        return scrollView
    }()
    
    private var askInterpolationPointsCountClosure: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize = NSSize(width: 800, height: 500)
        self.view.setFrameSize(viewSize)

        view.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(copyButton.snp.top).offset(-20)
        }
        
        output?.viewDidLoad()
    }

    func updateSummaryText(_ text: String) {
        summaryTextView.string = text
    }
    
    func askInterpolationPointsCount(closure: @escaping (Int) -> Void) {
        askInterpolationPointsCountClosure = closure
        showInterpolationPointsCountNotification()
    }
    
    @objc func copyButtonClicked() {
        output?.copySummaryText(summaryTextView.string)
    }
    
    private func showInterpolationPointsCountNotification() {
        let alert = NSAlert()
        alert.messageText = "Распознан сложный жест"
        alert.informativeText = "Введите число точек жеста:"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = inputTextField
        alert.beginSheetModal(for: self.view.window!) { [weak self] response in
            if response == .alertFirstButtonReturn {
                if let number = Int(inputTextField.stringValue) {
                    self?.askInterpolationPointsCountClosure?(number)
                }
            }
        }
    }
}
