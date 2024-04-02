//
//  AppsListModuleBuilder.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 27.03.2024.
//

import Cocoa

protocol AppsListModuleOutput: AnyObject {
    func moduleWantsToGoNextWithSelectedBundleID(_ bundleID: String)
}

protocol AppsListModuleInput: AnyObject {}

final class AppsListModuleBuilder {

    weak var moduleOutput: AppsListModuleOutput?
    private var deviceUUID: String
    
    init(moduleOutput: AppsListModuleOutput, deviceUUID: String) {
        self.moduleOutput = moduleOutput
        self.deviceUUID = deviceUUID
    }
    
    func build() -> NSViewController {
        let presenter = AppsListPresenter(selectedDeviceUUID: deviceUUID)
        presenter.moduleOutput = moduleOutput
        let view = AppsListViewController(output: presenter)
        presenter.view = view
        return view
    }
}
