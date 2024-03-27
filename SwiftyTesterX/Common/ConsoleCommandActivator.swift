//
//  ConsoleCommandActivator.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

final class ConsoleCommandActivator {

    func listSimulatorDevices() -> String? {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun" // Путь к xcrun
        process.arguments = ["simctl", "list", "devices"] // Аргументы команды
        process.standardOutput = Pipe() // Необходимо для получения вывода команды

        // Запускаем процесс
        process.launch()

        // Получаем стандартный вывод команды
        let pipe = process.standardOutput as! Pipe
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        }

        // Дожидаемся завершения выполнения команды
        process.waitUntilExit()
        return nil
    }
}
