//
//  AppTableViewCell.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 02.04.2024.
//

import Cocoa

final class AppTableViewCell: NSTableCellView {

    let nameLabel = NSTextField()
    let bundleIdLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with app: App) {
        nameLabel.stringValue = app.name
        bundleIdLabel.stringValue = app.bundleIdentifier
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        nameLabel.isEditable = false
        nameLabel.isBezeled = false
        nameLabel.isSelectable = false
        nameLabel.backgroundColor = .clear
        nameLabel.maximumNumberOfLines = 0
        nameLabel.font = .titleBarFont(ofSize: 23)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        addSubview(bundleIdLabel)
        bundleIdLabel.isEditable = false
        bundleIdLabel.isBezeled = false
        bundleIdLabel.isSelectable = false
        bundleIdLabel.backgroundColor = .clear
        bundleIdLabel.maximumNumberOfLines = 0
        bundleIdLabel.font = .titleBarFont(ofSize: 18)
        
        bundleIdLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.right.equalTo(nameLabel)
        }
    }
}
