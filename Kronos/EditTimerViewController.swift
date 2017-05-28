//
//  EditTimerViewController.swift
//  Kronos
//
//  Created by Raquel Calayo on 28/05/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol EditTimerViewControllerDelegate : class {
    func closeButtonTapped()
    func plusTimerTapped()
    func minusTimerTapped()
    func okButtonTapped()
}

class EditTimerViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    weak var editTimerDelegate : EditTimerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        editTimerDelegate?.closeButtonTapped()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        editTimerDelegate?.plusTimerTapped()
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        editTimerDelegate?.minusTimerTapped()
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        editTimerDelegate?.okButtonTapped()
    }
    

}
