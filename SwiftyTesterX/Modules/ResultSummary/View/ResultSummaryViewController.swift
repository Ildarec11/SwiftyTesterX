//
//  ResultSummaryViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

protocol ResultSummaryViewInput: AnyObject {
    func updateSummaryText(_ text: String)
    func createRequestFile(url: String, body: String)
}

protocol ResultSummaryViewOutput: AnyObject {
    func viewDidLoad()
    func viewDidToggleGestureSelect(isPanSelected: Bool)
    func copySummaryText(_ text: String)
    func viewDidUpdatedEnabledRequests(enabledRequests: [String: String])
}

final class ResultSummaryViewController: NSViewController, ResultSummaryViewInput {
    
    func createRequestFile(url: String, body: String) {
        // unused
    }

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
        
    @objc func copyButtonClicked() {
        output?.copySummaryText(summaryTextView.string)
    }
}
