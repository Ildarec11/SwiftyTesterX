//
//  AppsListViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 27.03.2024.
//

import Cocoa

protocol AppsListViewInput: AnyObject {
    func showAvailableApps(apps: [App])
}

protocol AppsListViewOutput: AnyObject {
    func viewDidLoad()
    func didSelectedApp(bundleID: String)
}

final class AppsListViewController: NSViewController, AppsListViewInput {
    
    private var output: AppsListViewOutput

    private var apps: [App] = []
    
    private let loader: NSProgressIndicator = {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.style = .spinning
        progressIndicator.controlSize = .regular
        progressIndicator.isIndeterminate = true
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(nil)
        return progressIndicator
    }()
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 150
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "public.data")])
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        column.title = "Apps"
        tableView.addTableColumn(column)

        tableView.allowsMultipleSelection = false
        return tableView
    }()

    init(output: AppsListViewOutput) {
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

        setupScrollView()
        setupLoader()
        output.viewDidLoad()
    }
    
    func showAvailableApps(apps: [App]) {
        loader.isHidden = true
        tableView.isHidden = false
        self.apps = apps
        tableView.reloadData()
    }

    private func setupLoader() {
        view.addSubview(loader)
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: NSTableViewDataSource

extension AppsListViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return apps[row]
    }
}

// MARK: NSTableViewDataSource

extension AppsListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
        var cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? AppTableViewCell
        if cell == nil {
            cell = AppTableViewCell(frame: .zero)
            cell?.identifier = cellIdentifier
        }
        
        let app = apps[row]
        cell?.configure(with: app)
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        
        let selectedRow = tableView.selectedRow

        let selectedApp = apps[selectedRow]
        output.didSelectedApp(bundleID: selectedApp.bundleIdentifier)
    }
}
