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
    private let logToTestConverter = GestureLogToTestConverter()
    private var simulatorLogCollector: SimulatorLogCollector!
    
    init(appBundleID: String) {
        self.appBundleID = appBundleID
    }
}

extension ResultSummaryPresenter: ResultSummaryViewOutput {

    func copySummaryText(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents() // Очищаем содержимое буфера обмена перед копированием новой информации
        pasteboard.setString(text, forType: .string) // Копируем текст из summaryTextView в буфер обмена
    }
    
    func viewDidLoad() {
        simulatorLogCollector = SimulatorLogCollector(delegate: self)

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
