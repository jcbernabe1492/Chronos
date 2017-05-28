//
//  EditTimerView.swift
//  Kronos
//
//  Created by Raquel Calayo on 27/05/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol EditTimerViewDelegate : class {
    func closeButtonTapped()
    func plusTimerTapped()
    func minusTimerTapped()
    func okButtonTapped()
}

class EditTimerView: UIView {
    
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
    
    weak var editTimerDelegate: EditTimerViewDelegate?
    
    class func instanceFromNib() -> EditTimerView {
        return UINib(nibName: "EditTimerView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! EditTimerView
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
