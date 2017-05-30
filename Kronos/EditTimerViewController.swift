//
//  EditTimerViewController.swift
//  Kronos
//
//  Created by Raquel Calayo on 28/05/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol EditTimerViewControllerDelegate : class {
    func okButtonTappedWithNewTime(time: Int)
    func updateTopLabels(min:Int, hrs:Int, days:Int)
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
    
    var tempTimeChange:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
        setTimeLabels(min: times.1, hrs: times.0, days: 0)
    }

    
// MARK: - IBAction Methods
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        
        tempTimeChange = tempTimeChange + 1
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        
        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
        
        setTimeLabels(min: times.1, hrs: times.0, days: 0)
        editTimerDelegate?.updateTopLabels(min: times.1, hrs: times.0, days: 0)
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        
        tempTimeChange = tempTimeChange - 1
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        
        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
        
        setTimeLabels(min: times.1, hrs: times.0, days: 0)
        editTimerDelegate?.updateTopLabels(min: times.1, hrs: times.0, days: 0)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        editTimerDelegate?.okButtonTappedWithNewTime(time: tempTimeChange)
        
        //ChronoTimer.sharedInstance.addtime(time: tempTimeChange)
        
        tempTimeChange = 0
        self.dismiss(animated: false, completion: nil)
    }
    
    
// MARK: - Helper Methods
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setTimeLabels(min: Int, hrs: Int, days: Int) {
        minutesLabel.text = String(format: "%02d", min)
        var d = 0
        var hours = hrs
        var intVal = 8
        if let i = UserDefaults.standard.value(forKey: "workHoursPerDay")
        {
            let i = Int(i as! String)
            if i != nil
            {
                intVal = i!
            }
        }
        while hours >= intVal
        {
            hours = hours - intVal
            d = d + 1
        }
        hoursLabel.text = String(format: "%02d", hours)
        daysLabel.text = String(format: "%02d", d)
    }

}
