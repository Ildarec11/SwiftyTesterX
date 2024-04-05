//
//  ResultSummaryViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

protocol ResultSummaryViewInput: AnyObject {
    func updateSummaryText(_ text: String)
}

protocol ResultSummaryViewOutput: AnyObject {
    func viewDidLoad()
    func copySummaryText(_ text: String)
}

final class ResultSummaryViewController: NSViewController, ResultSummaryViewInput {

    private var output: ResultSummaryViewOutput

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

    init(output: ResultSummaryViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        // Уведомляем презентера, что экран загружен
        output.viewDidLoad()
    }

    func updateSummaryText(_ text: String) {
        summaryTextView.string = text
        print("-- new text \(text)")
    }
    
    @objc func copyButtonClicked() {
        output.copySummaryText(summaryTextView.string)
    }
}
