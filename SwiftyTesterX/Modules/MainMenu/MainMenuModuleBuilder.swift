//
//  MainMenuModuleBuilder.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa
import Foundation

final class MainMenuModuleBuilder {
    
    private weak var moduleOutput: MainMenuModuleOutput?

    init(moduleOutput: MainMenuModuleOutput) {
        self.moduleOutput = moduleOutput
    }
    
    func build() -> NSViewController {
        let presenter = MainMenuPresenter()
        let viewController = MainViewController()
        viewController.output = presenter
        return viewController
    }
}
