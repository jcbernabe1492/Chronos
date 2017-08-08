//
//  SimpleTimerView.swift
//  Kronos
//
//  Created by John Christopher Bernabe on 05/08/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

class SimpleTimerView: UIView, SimpleTimerInterface {

    // Top Bar
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var calendarDaysWorkedLabel: UILabel!
    @IBOutlet weak var workingDayLengthLabel: UILabel!
    
    // Page Control
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Timer
    @IBOutlet weak var timerHolderView: UIView!
    @IBOutlet weak var timerHolderScroll: UIScrollView!
    @IBOutlet weak var timerHolderContent: UIView!
    
    // First Timer
    @IBOutlet weak var firstTimerView: UIView!
    @IBOutlet weak var firstTimerDays: UILabel!
    @IBOutlet weak var firstTimerHours: UILabel!
    @IBOutlet weak var firstTimerMinutes: UILabel!
    
    // Second Timer
    @IBOutlet weak var secondTimerView: UIView!
    @IBOutlet weak var secondTimerHours: UILabel!
    @IBOutlet weak var secondTimerMinutes: UILabel!
    @IBOutlet weak var secondTimerDays: UILabel!
    
    // Bottom Objects
    @IBOutlet weak var bottomHolder: UIView!
    @IBOutlet weak var timeAllocationsHolder: UIView!
    @IBOutlet weak var projectTimeAllocationLabel: UILabel!
    @IBOutlet weak var taskTimeAllocationLabel: UILabel!
    
    @IBOutlet weak var bottomFirstProject: UIView!
    @IBOutlet weak var bottomFirstProjectLabel: UILabel!
    @IBOutlet weak var bottomFirstProjectLine: UIView!
    @IBOutlet weak var bottomFirstTask: UIView!
    @IBOutlet weak var bottomFirstTaskLabel: UILabel!
    @IBOutlet weak var bottomFirstTaskLine: UIView!
    @IBOutlet weak var bottomFirstClient: UIView!
    @IBOutlet weak var bottomFirstClienLabel: UILabel!
    @IBOutlet weak var bottomFirstClientLine: UIView!
    @IBOutlet weak var bottomFirstAgency: UIView!
    @IBOutlet weak var bottomFirstAgencyLabel: UILabel!
    @IBOutlet weak var bottomFirstAgencyLine: UIView!
    
    @IBOutlet weak var bottomSecondProject: UIView!
    @IBOutlet weak var bottomSecondProjectLabel: UILabel!
    @IBOutlet weak var bottomSecondProjectLine: UIView!
    @IBOutlet weak var bottomSecondTask: UIView!
    @IBOutlet weak var bottomSecondTaskLabel: UILabel!
    @IBOutlet weak var bottomSecondTaskLine: UIView!
    @IBOutlet weak var bottomSecondClient: UIView!
    @IBOutlet weak var bottomSecondClientLabel: UILabel!
    @IBOutlet weak var bottomSecondClientLine: UIView!
    @IBOutlet weak var bottomSecondAgency: UIView!
    @IBOutlet weak var bottomSecondAgencyLabel: UILabel!
    @IBOutlet weak var bottomSecondAgencyLine: UIView!
    
    // Job Details
    @IBOutlet weak var jobDetailsStack: UIStackView!
    
    // Start Stop Button
    @IBOutlet weak var startStopButton: UIButton!
    
    var currentJobTime: Double?
    var jobItem: JobTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomFirstProject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstTask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstClient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstAgency.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        
        bottomSecondProject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondTask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondClient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondAgency.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
    }
    
    func handleFirstBottomSelection(gesture: UITapGestureRecognizer) {

        resetFirstBottomViewsSelection()
        
        let activeColor = UIColor(red: 255/255, green: 231/255, blue: 22/255, alpha: 1.0)
        
        if let viewTag = gesture.view?.tag {
            switch viewTag {
            case 0:
                bottomFirstProjectLabel.textColor = activeColor
                bottomFirstProjectLine.backgroundColor = activeColor
            case 1:
                bottomFirstTaskLabel.textColor = activeColor
                bottomFirstTaskLine.backgroundColor = activeColor
            case 2:
                bottomFirstClienLabel.textColor = activeColor
                bottomFirstClientLine.backgroundColor = activeColor
            case 3:
                bottomFirstAgencyLabel.textColor = activeColor
                bottomFirstAgencyLine.backgroundColor = activeColor
                
            default: break
            }
        }
    }
    
    private func resetFirstBottomViewsSelection() {
        let inactiveColor = UIColor.white
        
        bottomFirstProjectLabel.textColor = inactiveColor
        bottomFirstProjectLine.backgroundColor = inactiveColor
        bottomFirstTaskLabel.textColor = inactiveColor
        bottomFirstTaskLine.backgroundColor = inactiveColor
        bottomFirstClienLabel.textColor = inactiveColor
        bottomFirstClientLine.backgroundColor = inactiveColor
        bottomFirstAgencyLabel.textColor = inactiveColor
        bottomFirstAgencyLine.backgroundColor = inactiveColor
    }
    
    func handleSecondBottomSelection(gesture: UITapGestureRecognizer) {
        
        resetSecondBottomViewsSelection()
        
        let activeColor = UIColor(red: 255/255, green: 231/255, blue: 22/255, alpha: 1.0)
        
        if let viewTag = gesture.view?.tag {
            switch viewTag {
            case 0:
                bottomSecondProjectLabel.textColor = activeColor
                bottomSecondProjectLine.backgroundColor = activeColor
            case 1:
                bottomSecondTaskLabel.textColor = activeColor
                bottomSecondTaskLine.backgroundColor = activeColor
            case 2:
                bottomSecondClientLabel.textColor = activeColor
                bottomSecondClientLine.backgroundColor = activeColor
            case 3:
                bottomSecondAgencyLabel.textColor = activeColor
                bottomSecondAgencyLine.backgroundColor = activeColor
                
            default: break
            }
        }
    }
    
    private func resetSecondBottomViewsSelection() {
        let inactiveColor = UIColor.white
        
        bottomSecondProjectLabel.textColor = inactiveColor
        bottomSecondProjectLine.backgroundColor = inactiveColor
        bottomSecondTaskLabel.textColor = inactiveColor
        bottomSecondTaskLine.backgroundColor = inactiveColor
        bottomSecondClientLabel.textColor = inactiveColor
        bottomSecondClientLine.backgroundColor = inactiveColor
        bottomSecondAgencyLabel.textColor = inactiveColor
        bottomSecondAgencyLine.backgroundColor = inactiveColor
    }

    
// MARK: - Running Time
    
    func secondsPassing(seconds: Double) {
        currentJobTime = seconds
    }
    
// MARK: - Update  Values
    func updateValues(withCurrentTime: Double, jobTimer: JobTimer) {
        currentJobTime = withCurrentTime
        jobItem = jobTimer
        
        updateTimerValues()
        updateSecondsValue()
    }
    
    func computeCurrentTime() -> (days: Int, hours: Int, minutes: Int) {
        
//        currentJobTime
        
        return (1, 1, 1)
    }

// MARK: - Update Seconds Value
    
    private func updateSecondsValue() {
        self.startStopButton.setTitle("\(currentJobTime!)", for: .normal)
    }

// MARK: - Update Timer Values
    private func updateTimerValues() {
        let currentTimeValues = computeCurrentTime()
        
        firstTimerDays.text = "\(currentTimeValues.days)"
        firstTimerHours.text = "\(currentTimeValues.hours)"
        firstTimerMinutes.text = "\(currentTimeValues.minutes)"
        
        secondTimerDays.text = "\(currentTimeValues.days)"
        secondTimerHours.text = "\(currentTimeValues.hours)"
        secondTimerMinutes.text = "\(currentTimeValues.minutes)"
        
        
    }

// MARK: - Update Top Bar Values
    private func updateTopBarValues() {
        
    }

// MARK: - Update Middle Bar Values
    private func updateMiddleBarValues() {
        
    }
    
// MARK: - Update Bottom Values
    private func updateBottomValues() {
        
    }
    
// MARK: - Helper Functions
    
     private func getDaysHoursMinFrom(time:Double, dayLength:Int) -> (days: Int, hours: Int, minutes: Int) {
        
        var days = 0
        var hours = 0
        var minutes = 0
        var currentTime = time
        
        while Int(currentTime/3600) >= dayLength
        {
            days = days + 1
            currentTime = currentTime - (Double(dayLength)*3600.0)
        }
        while Int(currentTime/60) >= 60
        {
            hours = hours + 1
            currentTime = currentTime - 3600
        }
        while currentTime >= 60
        {
            minutes = minutes + 1
            currentTime = currentTime - 60
        }
        
        return (days, hours, minutes)
    }
    
    @IBAction func startStopTimer(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        
    }
}
