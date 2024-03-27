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
        // Insert code here to initialize your application
        let window = NSWindow()
        window.title = "SwiftyTesterX"
        startMainFlowCoordinator(window: window)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func startMainFlowCoordinator(window: NSWindow) {
        rootFlowCoordinator = MainMenuFlowCoordinator()
        rootFlowCoordinator.start(window: window)
    }
}

