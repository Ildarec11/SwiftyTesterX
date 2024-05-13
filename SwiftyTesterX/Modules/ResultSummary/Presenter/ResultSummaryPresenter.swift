//
//  ResultSummaryPresenter.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

final class ResultSummaryPresenter {

    weak var moduleOutput: ResultSummaryModuleOutput?
    weak var view: ResultSummaryViewInput?

    private let appBundleID: String
    
    private let consoleCommandActivator = ConsoleCommandActivator()
    private var logToTestConverter: GestureLogToTestConverter!
    private var simulatorLogCollector: SimulatorLogCollector!
    
    init(appBundleID: String) {
        self.appBundleID = appBundleID
    }
}

extension ResultSummaryPresenter: ResultSummaryViewOutput {

    func viewDidUpdatedEnabledRequests(enabledRequests: [String : String]) {
        logToTestConverter.updateEnabledRequests(enabledRequests)
        let currentString = logToTestConverter.getCurrentTestString()
        view?.updateSummaryText(currentString)
    }
    

    func viewDidToggleGestureSelect(isPanSelected: Bool) {
        logToTestConverter.isPanGesturePrefered = isPanSelected
    }
    
    func copySummaryText(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    func viewDidLoad() {
        simulatorLogCollector = SimulatorLogCollector(delegate: self)
        logToTestConverter = GestureLogToTestConverter(delegate: self)

        DispatchQueue.main.async {
            self.consoleCommandActivator.startApp(bundleID: self.appBundleID)
            self.simulatorLogCollector.runSimulatorLogStreaming()
        }
    }
}

extension ResultSummaryPresenter: SimulatorLogDelegate {

    func didReceiveValue(_ value: String) {
        logToTestConverter.addLogValueToTest(value)
        let currentString = logToTestConverter.getCurrentTestString()
        view?.updateSummaryText(currentString)
    }
}

extension ResultSummaryPresenter: GestureLogToTestConverterDelegate {

    func addNewRequestFile(url: String, body: String) {
        view?.createRequestFile(url: url, body: body)
    }
}
