//
//  SimulatorsListPresenter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Foundation

protocol SimulatorsListPresenterInput: AnyObject {}

protocol SimulatorsListPresenterOutput: AnyObject {}

final class SimulatorsListPresenter: SimulatorsListPresenterInput {
    
    private let consoleCommandActivator = ConsoleCommandActivator()
    private let devicesParser = DeviceInfoParser()
    
    weak var moduleOutput: SimulatorsListModuleOutput?
    weak var view: SimulatorsListViewInput?
    
    private func loadDevicesList() {
        guard let infoString = consoleCommandActivator.listSimulatorDevices() else {
            print("-- Something went wrong")
            return
        }

        let deviceList = devicesParser.parseDevicesInfo(infoString)
        view?.showAvailableDevices(devices: deviceList)
    }
}

// MARK: SimulatorsListViewOutput

extension SimulatorsListPresenter: SimulatorsListViewOutput {
    
    func viewDidLoad() {
        loadDevicesList()
    }
}
