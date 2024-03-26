//
//  MainMenuFlowCoordinator.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa
import Foundation

final class MainMenuFlowCoordinator {
    
    func start(window: NSWindow) {
        let builder = MainMenuModuleBuilder(moduleOutput: self)
        let vc = builder.build()
        window.contentViewController = vc
    }
}

extension MainMenuFlowCoordinator: MainMenuModuleOutput {
    
    func moduleWantsToGoNext(_ input: MainMenuModuleInput) {
        
    }
}
