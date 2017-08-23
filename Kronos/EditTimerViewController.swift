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
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonY: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    weak var editTimerDelegate : EditTimerViewControllerDelegate?
    
    var tempTimeChange:Int = 0
    
    var changeTimer: Timer?
    
    var buttonFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
        setTimeLabels(min: times.1, hrs: times.0, days: 0)
        
        let plusLongPress = UILongPressGestureRecognizer.init(target: self, action: #selector(startPlusTimer(gesture:)))
        plusLongPress.minimumPressDuration = 1
        plusButton.addGestureRecognizer(plusLongPress)
        plusButton.addTarget(self, action: #selector(plusReleased), for: .touchUpInside)
        
        let minusLongPress = UILongPressGestureRecognizer.init(target: self, action: #selector(startMinusTimer(gesture:)))
        minusLongPress.minimumPressDuration = 1
        minusButton.addGestureRecognizer(minusLongPress)
        minusButton.addTarget(self, action: #selector(minusReleased), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let halfScreenHeight = UIScreen.main.bounds.size.height/2
//        let newCloseButtonY = halfScreenHeight - (buttonFrame?.origin.y)!
        self.closeButtonY.constant = (buttonFrame?.origin.y)! + (buttonFrame?.size.height)!/2
    }
    
// MARK: - IBAction Methods
    @IBAction func closeButtonTapped(_ sender: Any) {
        changeTimer?.invalidate()
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func addTime(byValue: Int) {
        tempTimeChange = tempTimeChange + byValue
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        
        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
        
        setTimeLabels(min: times.1, hrs: times.0, days: 0)
        editTimerDelegate?.updateTopLabels(min: times.1, hrs: times.0, days: 0)
    }
    
    func subtractTime(byValue: Int) {
        tempTimeChange = tempTimeChange - byValue
        
        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
        
        if tempTime <= 0 {
            tempTimeChange = tempTimeChange + 1
            
        } else {
            let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
            
            setTimeLabels(min: times.1, hrs: times.0, days: 0)
            editTimerDelegate?.updateTopLabels(min: times.1, hrs: times.0, days: 0)
        }
    }
    
    func plusReleased() {
        endTimer(toAddTime: true)
    }
    
    func minusReleased() {
        endTimer(toAddTime: false)
    }
    
    func endTimer(toAddTime: Bool) {
        if changeTimer != nil {
            changeTimer?.invalidate()
            changeTimer = nil
        } else {
            if toAddTime {
                addTime(byValue: 1)
            } else {
                subtractTime(byValue: 1)
            }
        }
    }
    
    func startPlusTimer(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            if changeTimer == nil {
                changeTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(plusTimerRun), userInfo: nil, repeats: true)
            }
        } else if gesture.state == .ended {
            plusReleased()
        }
    }
    
    func startMinusTimer(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            if changeTimer == nil {
                changeTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(minusTimerRun), userInfo: nil, repeats: true)
            }
        } else if gesture.state == .ended {
            minusReleased()
        }
    }
    
    func plusTimerRun() {
        addTime(byValue: 2)
    }
    
    func minusTimerRun() {
        subtractTime(byValue: 2)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        if self.tempTimeChange != 0 {
            editTimerDelegate?.okButtonTappedWithNewTime(time: tempTimeChange)
            tempTimeChange = 0
        }
    
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
