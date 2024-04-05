//
//  SimulatorsListViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

protocol SimulatorsListViewOutput: AnyObject {
    func viewDidLoad()
    func didSelectSimulator(deviceUUID: String)
}

protocol SimulatorsListViewInput: AnyObject {
    func showAvailableDevices(devices: [Device])
}

final class SimulatorsListViewController: NSViewController, SimulatorsListViewInput {
    
    private var output: SimulatorsListViewOutput
    
    private var devices: [Device] = []
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 150
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "public.data")])
        
        // Adding columns
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        column.title = "Devices"
        tableView.addTableColumn(column)

        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    init(output: SimulatorsListViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()

        let viewSize = NSSize(width: 800, height: 500)
        self.view.setFrameSize(viewSize)
        setupScrollView()
    }
    
    func showAvailableDevices(devices: [Device]) {
        self.devices = devices
        tableView.reloadData()
    }
    
    private func setupScrollView() {
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: NSTableViewDataSource

extension SimulatorsListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return devices[row]
    }
}

// MARK: NSTableViewDataSource

extension SimulatorsListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
        var cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? DeviceTableViewCell
        if cell == nil {
            cell = DeviceTableViewCell(frame: .zero)
            cell?.identifier = cellIdentifier
        }
        
        let device = devices[row]
        cell?.configure(with: device)
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        
        let selectedRow = tableView.selectedRow

        let selectedDevice = devices[selectedRow]
        output.didSelectSimulator(deviceUUID: selectedDevice.identifier)
    }
}
