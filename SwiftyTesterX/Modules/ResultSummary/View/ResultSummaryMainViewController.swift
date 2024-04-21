//
//  ResultSummaryMainViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 20.04.2024.
//

import Cocoa

final class ResultSummaryMainViewController: NSSplitViewController {

    private weak var output: ResultSummaryViewOutput?
    
    private let resultSummaryViewController = ResultSummaryViewController()
    private let sideBarViewController = ResultSummarySideBarViewController()
    
    private let toolbar = NSToolbar(identifier: "MainToolbar")
    
    init(output: ResultSummaryViewOutput? = nil) {
        super.init(nibName: nil, bundle: nil)
        resultSummaryViewController.output = output
        sideBarViewController.output = output
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupToolbar()
    }
    
    private func setupUI() {
        view.wantsLayer = true
        
        splitView.dividerStyle = .paneSplitter
        splitView.autosaveName = NSSplitView.AutosaveName()
    }
    
    private func setupToolbar() {
        toolbar.delegate = self
        
        toolbar.displayMode = .iconOnly
        toolbar.sizeMode = .regular
        toolbar.insertItem(withItemIdentifier: .toggleSidebar, at: 0)
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 1)

        NSApplication.shared.windows.first?.toolbar = toolbar
        NSApplication.shared.windows.first?.toolbarStyle = .expanded
    }
    
    private func setupLayout() {
        
        minimumThicknessForInlineSidebars = 180
        
        let itemA = NSSplitViewItem(sidebarWithViewController: sideBarViewController)
        itemA.minimumThickness = 80
        addSplitViewItem(itemA)
        
        let itemB = NSSplitViewItem(contentListWithViewController: resultSummaryViewController)
        itemB.minimumThickness = 500
        addSplitViewItem(itemB)
        
        view.frame = CGRect(x: 0, y: 0, width: 800, height: 500)
    }
}

extension ResultSummaryMainViewController: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .toggleSidebar:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            
            
            return item
        case .space:
            let flexibleSpaceItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.space)
            return flexibleSpaceItem
        default:
            return nil
        }
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        return [.toggleSidebar]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        return [.toggleSidebar]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        return [.toggleSidebar]
    }
}

extension ResultSummaryMainViewController: ResultSummaryViewInput {

    func askInterpolationPointsCount(closure: @escaping (Int) -> Void) {
        resultSummaryViewController.askInterpolationPointsCount(closure: closure)
    }

    func updateSummaryText(_ text: String) {
        resultSummaryViewController.updateSummaryText(text)
    }
}
