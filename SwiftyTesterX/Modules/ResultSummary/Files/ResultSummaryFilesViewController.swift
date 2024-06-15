//
//  ResultSummaryFilesViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 23.05.2024.
//

import Cocoa

protocol ResultSummaryFilesViewInput {
    func createRequestFile(url: String, body: String)
}

final class ResultSummaryFilesViewController: NSViewController, ResultSummaryFilesViewInput {

    weak var output: ResultSummaryViewOutput?
    private var createdFiles: [String: String] = [:]
    private var enabledFiles: [String: Bool] = [:] {
        didSet {
            let keys = enabledFiles.filter {
                $0.value == true
            }.keys
            
            let filteredDictionary = createdFiles.filter { keys.contains($0.key) }
            
            output?.viewDidUpdatedEnabledRequests(enabledRequests: filteredDictionary)
        }
    }
    
    func createRequestFile(url: String, body: String) {
        createdFiles[url] = body
        enabledFiles[url] = false
        tableView.reloadData()
    }

    private let tableView = NSTableView()
    private let scrollView = NSScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("FilesColumn"))
        column.title = "Files"
        tableView.addTableColumn(column)
        tableView.headerView = nil
        tableView.dataSource = self
        tableView.delegate = self
        
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false

        view.addSubview(scrollView)
        tableView.registerForDraggedTypes([.fileURL])
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 900)
    }
    
    func editRequestBody(url: String, currentBody: String, completion: @escaping (String?) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Edit Request Body"
        alert.informativeText = "Edit the body for the request to \(url)"
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 400, height: 200))
        textView.string = currentBody
        textView.isEditable = true
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        alert.accessoryView = textView
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            completion(textView.string)
        } else {
            completion(nil)
        }
    }
}

extension ResultSummaryFilesViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return createdFiles.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let fileKeys = Array(createdFiles.keys)
        let url = fileKeys[row]
        
        let cellView = NSView(frame: NSRect(x: 0, y: 0, width: tableView.frame.width, height: 150))

        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .centerY
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let checkBox = NSButton(checkboxWithTitle: "", target: self, action: #selector(checkboxClicked(_:)))
        checkBox.tag = row
        checkBox.state = enabledFiles[url] == true ? .on : .off
        stackView.addArrangedSubview(checkBox)
        
        let editButton = NSButton(title: "Edit", target: self, action: #selector(editButtonClicked(_:)))
        editButton.tag = row
        stackView.addArrangedSubview(editButton)

        let fileView = DraggableFileView(
            frame: NSRect(x: 0, y: 0, width: 200, height: 120),
            filePath: url,
            fileContent: createdFiles[url]!
        )
        fileView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(fileView)
        cellView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0)
        ])

        return cellView
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    @objc func checkboxClicked(_ sender: NSButton) {
        let row = sender.tag
        let isChecked = (sender.state == .on)
        let arrayKeys = Array(createdFiles.keys)
        let urlKey = arrayKeys[row]
        enabledFiles[urlKey] = isChecked
    }
    
    @objc func editButtonClicked(_ sender: NSButton) {
        let row = sender.tag
        let arrayKeys = Array(createdFiles.keys)
        let urlKey = arrayKeys[row]
        guard let currentBody = createdFiles[urlKey] else { return }
        editRequestBody(url: urlKey, currentBody: currentBody) { [weak self] editedBody in
            if let editedBody = editedBody {
                self?.createdFiles[urlKey] = editedBody
                self?.tableView.reloadData()
            }
        }
    }
}
