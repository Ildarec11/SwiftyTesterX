//
//  MainViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa
import SnapKit

protocol MainViewControllerOutput: AnyObject {

    func recordButtonDidPressed()
}

protocol MainViewControllerInput: AnyObject {}

final class MainViewController: NSViewController {
    
    var output: MainViewControllerOutput
    
    init(output: MainViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize = NSSize(width: 800, height: 500)
        self.view.setFrameSize(viewSize)
        
        setupBlurEffect()
        setupRecordButton()
        setupLabel()
        setupImageView()
    }
    
    private func setupLabel() {
        let label = NSTextField(labelWithString: "SwiftTesterX")
        label.font = NSFont.systemFont(ofSize: 36)
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(150)
        }
    }
    
    private func setupRecordButton() {
        let button = NSButton(title: "Record", target: self, action: #selector(recordButtonDidPressed))
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func setupImageView() {
    
        let imageView = NSImageView(image: NSImage(named: "SwiftIcon")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }
    
    private func setupBlurEffect() {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        // Устанавливаем стиль размытия (блюра)
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        
        // Добавляем NSVisualEffectView на вью контроллер
        self.view.addSubview(visualEffectView)
        
        // Устанавливаем констрейнты для NSVisualEffectView
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainViewController: MainViewControllerOutput {
    
    @objc func recordButtonDidPressed() {
        output.recordButtonDidPressed()
    }
}
