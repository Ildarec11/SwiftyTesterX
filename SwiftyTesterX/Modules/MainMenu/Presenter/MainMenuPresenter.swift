//
//  MainMenuPresenter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Foundation

protocol MainMenuModuleInput: AnyObject {
    
}

protocol MainMenuModuleOutput: AnyObject {
    func moduleWantsToGoNext(_ input: MainMenuModuleInput)
}

final class MainMenuPresenter: MainMenuModuleInput {
    
    weak var moduleOutput: MainMenuModuleOutput?
}

extension MainMenuPresenter: MainViewControllerOutput {

    func recordButtonDidPressed() {
        moduleOutput?.moduleWantsToGoNext(self)
    }
}
