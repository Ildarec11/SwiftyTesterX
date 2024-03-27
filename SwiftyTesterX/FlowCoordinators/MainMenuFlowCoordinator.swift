//
//  MainMenuFlowCoordinator.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa
import Foundation

final class MainMenuFlowCoordinator {
    
    private var window: NSWindow!
    
    func start(window: NSWindow) {
        self.window = window
        let builder = MainMenuModuleBuilder(moduleOutput: self)
        let vc = builder.build()
        window.contentViewController = vc
        window.makeKeyAndOrderFront(nil)
    }
}

extension MainMenuFlowCoordinator: MainMenuModuleOutput {
    
    func moduleWantsToGoNext(_ input: MainMenuModuleInput) {
        let builder = SimulatorsListModuleBuilder(moduleOutput: self)
        let vc = builder.build()
        window.contentViewController = vc
        window.makeKeyAndOrderFront(nil)
    }
}

extension MainMenuFlowCoordinator: SimulatorsListModuleOutput {}
