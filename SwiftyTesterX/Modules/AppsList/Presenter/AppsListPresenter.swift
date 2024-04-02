//
//  AppsListPresenter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 27.03.2024.
//

import Foundation

final class AppsListPresenter {

    weak var moduleOutput: AppsListModuleOutput?
    weak var view: AppsListViewInput?
    
    private let selectedDeviceUUID: String
    private let consoleCommandActivator = ConsoleCommandActivator()
    private let appsParser = AppsParser()
    
    init(selectedDeviceUUID: String) {
        self.selectedDeviceUUID = selectedDeviceUUID
    }
    
    private func showAvailableApps() {
        consoleCommandActivator.bootSimulator(deviceUUID: selectedDeviceUUID)
        guard let appsListString = consoleCommandActivator.appsList(deviceUUID: selectedDeviceUUID) else {
            print("-- Something went wrong. Failed fetch apps")
            return
        }
        let apps = appsParser.parseAvailableApps(appsListString)
        view?.showAvailableApps(apps: apps)
    }
}

extension AppsListPresenter: AppsListViewOutput {

    func viewDidLoad() {
        showAvailableApps()
    }
    
    func didSelectedApp() {
        // unused
    }
}
