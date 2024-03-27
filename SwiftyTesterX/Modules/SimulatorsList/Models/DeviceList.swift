//
//  DeviceList.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

struct DeviceList {
    var iOSDevices: [Device]
    var watchOSDevices: [Device]
    var tvOSDevices: [Device]
    
    init() {
        self.iOSDevices = []
        self.watchOSDevices = []
        self.tvOSDevices = []
    }
}
