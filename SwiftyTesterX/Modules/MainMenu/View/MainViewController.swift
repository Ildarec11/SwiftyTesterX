//
//  MainViewController.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 26.03.2024.
//

import Cocoa

protocol MainViewControllerOutput: AnyObject {
    func recordButtonDidPressed()
}

protocol MainViewControllerInput: AnyObject {}

final class MainViewController: NSViewController {
    
    weak var output: MainViewControllerOutput?

    @IBAction func recordButtonDidPressed(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension MainViewController: MainViewControllerOutput {

    func recordButtonDidPressed() {
        //
    }
}
