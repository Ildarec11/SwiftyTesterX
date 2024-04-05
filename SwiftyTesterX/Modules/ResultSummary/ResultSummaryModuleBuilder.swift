//
//  ResultSummaryModuleBuilder.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

protocol ResultSummaryModuleOutput: AnyObject {}

final class ResultSummaryModuleBuilder {

    weak var moduleOutput: ResultSummaryModuleOutput?

    private var appBundleID: String
    
    init(moduleOutput: ResultSummaryModuleOutput, appBundleID: String) {
        self.moduleOutput = moduleOutput
        self.appBundleID = appBundleID
    }
    
    func build() -> NSViewController {
        let presenter = ResultSummaryPresenter(appBundleID: appBundleID)
        presenter.moduleOutput = moduleOutput
        let view = ResultSummaryViewController(output: presenter)
        presenter.view = view
        return view
    }
}
