//
//  DeviceTableViewCell.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 27.03.2024.
//

import Cocoa
import SnapKit

final class DeviceTableViewCell: NSTableCellView {
    let nameLabel = NSTextField()
    let identifierLabel = NSTextField()
    let statusLabel = NSTextField()
    let osLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with device: Device) {
        nameLabel.stringValue = device.name
        identifierLabel.stringValue = "\(device.identifier)"
        statusLabel.stringValue = "\(device.status)"
        osLabel.stringValue = "\(device.os)"

    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(identifierLabel)
        addSubview(statusLabel)
        addSubview(osLabel)
        
        nameLabel.isEditable = false
        identifierLabel.isEditable = false
        statusLabel.isEditable = false
        osLabel.isEditable = false
        
        nameLabel.isBezeled = false
        identifierLabel.isBezeled = false
        statusLabel.isBezeled = false
        osLabel.isBezeled = false
        
        nameLabel.isSelectable = false
        identifierLabel.isSelectable = false
        statusLabel.isSelectable = false
        osLabel.isSelectable = false
        
        nameLabel.backgroundColor = .clear
        identifierLabel.backgroundColor = .clear
        statusLabel.backgroundColor = .clear
        osLabel.backgroundColor = .clear
        
        nameLabel.maximumNumberOfLines = 0
        identifierLabel.maximumNumberOfLines = 0
        statusLabel.maximumNumberOfLines = 0
        osLabel.maximumNumberOfLines = 0
        
        nameLabel.font = .titleBarFont(ofSize: 23)
        
        // SnapKit constraints
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        identifierLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(identifierLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-8)
        }
        
        osLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
