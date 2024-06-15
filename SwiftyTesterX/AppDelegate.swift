//
//  AppDelegate.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private var rootFlowCoordinator: MainMenuFlowCoordinator!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let window = NSWindow(contentRect: NSRect(origin: .zero, size: .init(width: 2000, height: 1000)),
                              styleMask: [.titled, .closable, .resizable, .miniaturizable],
                              backing: .buffered,
                              defer: false)

        window.title = "SwiftyTesterX"
        startMainFlowCoordinator(window: window)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // unused
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func startMainFlowCoordinator(window: NSWindow) {
        rootFlowCoordinator = MainMenuFlowCoordinator()
        rootFlowCoordinator.start(window: window)
    }
}

