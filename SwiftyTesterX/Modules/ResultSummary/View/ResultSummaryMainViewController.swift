import Cocoa

extension NSToolbarItem.Identifier {
    static let toggleSidebar = NSToolbarItem.Identifier("toggleSidebar")
    static let toggleRequestView = NSToolbarItem.Identifier("toggleRequestView")
}

final class ResultSummaryMainViewController: NSSplitViewController {

    private weak var output: ResultSummaryViewOutput?
    
    private let resultSummaryViewController = ResultSummaryViewController()
    private let sideBarViewController = ResultSummarySideBarViewController()
    private let requestViewController = ResultSummaryFilesViewController()
    
    private let toolbar = NSToolbar(identifier: "MainToolbar")
    
    init(output: ResultSummaryViewOutput? = nil) {
        super.init(nibName: nil, bundle: nil)
        resultSummaryViewController.output = output
        sideBarViewController.output = output
        requestViewController.output = output
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
        toolbar.delegate = self
        toolbar.sizeMode = .default
        toolbar.insertItem(withItemIdentifier: .toggleSidebar, at: 0)
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 1)
        toolbar.insertItem(withItemIdentifier: .toggleRequestView, at: 2)

        NSApplication.shared.windows.first?.toolbar = toolbar
        NSApplication.shared.windows.first?.toolbarStyle = .expanded
    }
    
    private func setupLayout() {
                
        let itemA = NSSplitViewItem(sidebarWithViewController: sideBarViewController)
        itemA.minimumThickness = 100
        itemA.maximumThickness = 300
        itemA.isCollapsed = true
        addSplitViewItem(itemA)
        
        let itemB = NSSplitViewItem(contentListWithViewController: resultSummaryViewController)
        itemB.minimumThickness = 500
        addSplitViewItem(itemB)

        let itemC = NSSplitViewItem(viewController: requestViewController)
        itemC.minimumThickness = 400
        itemC.isCollapsed = true
        addSplitViewItem(itemC)
        
        view.frame = CGRect(x: 0, y: 0, width: 1200, height: 500)
    }
    
    @objc internal override func toggleSidebar(_ sender: Any?) {
        guard let splitViewItem = splitViewItems.first else { return }
        splitViewItem.isCollapsed.toggle()
    }

    @objc internal func toggleRequestView(_ sender: Any?) {
        guard let requestViewItem = splitViewItems.last else { return }
        requestViewItem.isCollapsed.toggle()
    }
}

extension ResultSummaryMainViewController: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .toggleSidebar:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Toggle Sidebar"
            item.paletteLabel = "Toggle Sidebar"
            item.toolTip = "Show or hide the sidebar"
            item.target = self
            item.action = #selector(toggleSidebar(_:))
            item.image = NSImage(systemSymbolName: "sidebar.left", accessibilityDescription: "Toggle Sidebar")
            return item
        case .toggleRequestView:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Toggle Requests"
            item.paletteLabel = "Toggle Requests"
            item.toolTip = "Show or hide the request view"
            item.target = self
            item.action = #selector(toggleRequestView(_:))
            item.image = NSImage(systemSymbolName: "sidebar.right", accessibilityDescription: "Toggle Requests")
            return item
        case .flexibleSpace:
            return NSToolbarItem(itemIdentifier: .flexibleSpace)
        default:
            return nil
        }
    }
        
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .toggleRequestView, .flexibleSpace]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .flexibleSpace, .toggleRequestView]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
}

extension ResultSummaryMainViewController: ResultSummaryViewInput {
    
    func createRequestFile(url: String, body: String) {
        requestViewController.createRequestFile(url: url, body: body)
    }

    func updateSummaryText(_ text: String) {
        resultSummaryViewController.updateSummaryText(text)
    }
}
