//
//  SimulatorsListModuleBuilder.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

protocol SimulatorsListModuleOutput: AnyObject {}

protocol SimulatorsListModuleInput: AnyObject {}

final class SimulatorsListModuleBuilder {
    
    weak var moduleOutput: SimulatorsListModuleOutput?
    
    init(moduleOutput: SimulatorsListModuleOutput) {
        self.moduleOutput = moduleOutput
    }
    
    func build() -> NSViewController {
        let presenter = SimulatorsListPresenter()
        presenter.moduleOutput = moduleOutput
        let view = SimulatorsListViewController(output: presenter)
        presenter.view = view
        return view
    }
}
