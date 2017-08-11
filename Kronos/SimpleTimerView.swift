//
//  SimpleTimerView.swift
//  Kronos
//
//  Created by John Christopher Bernabe on 05/08/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import UIKit

protocol SimpleTimerViewDelegate: class {
    func startTimer()
    func stopTimer()
    func showEditTimer(buttonFrame: CGRect)
}

class SimpleTimerView: UIView, SimpleTimerInterface, TimerProtocol {
    
    weak var simpleTimerDelegate: SimpleTimerViewDelegate?
    
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
   
    // First Row Detail Labels
    @IBOutlet weak var bottomFirstIncomeLabel: UILabel!
    @IBOutlet weak var bottomFirstNameLabel: UILabel!
    
    // First Row Selectables
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
    
    // Second Row Detail Labels
    @IBOutlet weak var bottomSecondIncomeLabel: UILabel!
    @IBOutlet weak var bottomSecondNameLabel: UILabel!
    
    // Second Row Selectables
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
    @IBOutlet weak var secondsLabel: UILabel!
    
    // Current Job Time
    var currentJobTime: Double?
    
    // Job Related Objects
    var jobItem: JobTimer?
    var jobTask: StageTask?
    var jobProject: Project?
    var jobClient: Agency?
    var jobAgency: Agency?
    
    // Day Length
    var dayLength: Int?
    
    var firstRowSelectedTag: Int!
    var secondRowSelectedTag: Int!

    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed(tap:)))
        longpress.minimumPressDuration = 1
        startStopButton.addGestureRecognizer(longpress)
        
        bottomFirstProject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstTask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstClient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        bottomFirstAgency.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstBottomSelection(gesture:))))
        
        bottomSecondProject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondTask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondClient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        bottomSecondAgency.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondBottomSelection(gesture:))))
        
        let activeColor = UIColor(red: 255/255, green: 231/255, blue: 22/255, alpha: 1.0)
        bottomFirstTaskLabel.textColor = activeColor
        bottomFirstTaskLine.backgroundColor = activeColor
        bottomSecondProjectLabel.textColor = activeColor
        bottomSecondProjectLine.backgroundColor = activeColor
        
        ChronoTimer.sharedInstance.delegates.append(self)
    }
    
// MARK: - Running Time
    
    func secondsPassing(seconds: Double) {
        currentJobTime = seconds
    }
    
// MARK: - Update  Values
    func updateValues(withCurrentTime: Double, jobTimer: JobTimer) {
        currentJobTime = withCurrentTime
        jobItem = jobTimer
        
        // Retrieve job related details
        self.jobTask = StageTask.getStageTask(forId: jobItem?.stageTaskId as! Int)
        self.jobProject = Project.getProject(forId: (self.jobTask?.projectId.intValue)!)
        self.jobClient = DataController.sharedInstance.getClientForTaskId(id: (self.jobItem?.stageTaskId.intValue)!)
        self.jobAgency = DataController.sharedInstance.getAgencyForTask(id: (self.jobItem?.stageTaskId.intValue)!)
        
        // Retrieve day length based on saved day length of the project
        self.dayLength = self.jobProject?.dayLength.intValue
        
        // Update Timer Values
        updateTimerValues()
        updateSecondsValue()
        updateTopBarValues()
        updateMiddleBarValues()
        
        // Preselect bottom part selections
        firstRowSelectedTag = 1
        showTaskDetails(firstRow: true)
        secondRowSelectedTag = 0
        showProjectDetails(firstRow: false)
    }
    
    func startAsActiveTimer() {
        self.startStopButton.isSelected = true
        self.secondsLabel.isHidden = false;
        self.startStopButton.setImage(UIImage(named:"btn-timer-active-numbered"), for: .normal)
    }
    
    func stopActiveTimer() {
        self.startStopButton.isSelected = false
        self.secondsLabel.isHidden = true;
        self.startStopButton.setImage(UIImage(named:"btn-timer-stopped-big"), for: .normal)
    }
    
// MARK: - Update Seconds Value
    
    private func updateSecondsValue() {
        self.secondsLabel.text = computeCurrentSecondsPerMinute()
    }

// MARK: - Update Timer Values
    private func updateTimerValues() {
        let currentTimeValues = computeCurrentTime(time: self.currentJobTime!)
        
        firstTimerDays.text = "\(currentTimeValues.days)"
        firstTimerHours.text = "\(currentTimeValues.hours)"
        firstTimerMinutes.text = "\(currentTimeValues.minutes)"
        
        secondTimerDays.text = "\(currentTimeValues.days)"
        secondTimerHours.text = "\(currentTimeValues.hours)"
        secondTimerMinutes.text = "\(currentTimeValues.minutes)"
    }

// MARK: - Update Top Bar Values
    private func updateTopBarValues() {
        self.calendarDaysWorkedLabel.text = "CALENDAR DAYS WORKED = \(ArchiveUtils.getDaysWorked(task: (self.jobTask?.id)!))"
        self.workingDayLengthLabel.text = String(format: "%i = WORKING DAY LENGTH", (self.jobProject?.dayLength.intValue)!)
    }

// MARK: - Update Middle Bar Values
    private func updateMiddleBarValues() {
        let projectAllocatedSeconds = ((self.jobProject?.allocatedProjectTime.doubleValue)!*60)*60
        let projectAllocation = getDaysHoursMinFrom(time: projectAllocatedSeconds, dayLength: self.jobProject?.dayLength as! Int)
        
        var daysString = ""
        if projectAllocation.days != 0 {
            
            if projectAllocation.days > 1{
                daysString = "\(projectAllocation.days) DAYS"
            } else {
                daysString = "\(projectAllocation.days) DAY"
            }
        }
        
        if projectAllocation.hours > 1 {
            self.projectTimeAllocationLabel.text = "\(daysString) \(projectAllocation.hours) HOURS"
        } else {
            self.projectTimeAllocationLabel.text = "\(daysString) \(projectAllocation.hours) HOUR"
        }
        
        let taskAllocatedSeconds = ((self.jobTask?.allocatedTaskTime.doubleValue)!*60)*60
        let taskAllocation = getDaysHoursMinFrom(time: taskAllocatedSeconds, dayLength: self.jobProject?.dayLength as! Int)
        var taskDayString = ""
        if taskAllocation.days != 0 {
            
            if taskAllocation.days > 1 {
                taskDayString = "\(taskAllocation.days) DAYS"
            } else {
                taskDayString = "\(taskAllocation.days) DAY"
            }
        }
        
        if taskAllocation.hours > 1 {
            self.taskTimeAllocationLabel.text = "\(taskDayString) \(taskAllocation.hours) HOURS"
        } else {
            self.taskTimeAllocationLabel.text = "\(taskDayString) \(taskAllocation.hours) HOUR"
        }
    }
    
// MARK: - Update Bottom Values
    private func updateBottomValues() {
        
        switch firstRowSelectedTag {
            case 0: showProjectDetails(firstRow: true)
            case 1: showTaskDetails(firstRow: true)
            case 2: showClientDetails(firstRow: true)
            case 3: showAgencyDetails(firstRow: true)
            default: break
        }
        
        switch secondRowSelectedTag {
            case 0: showProjectDetails(firstRow: false)
            case 1: showTaskDetails(firstRow: false)
            case 2: showClientDetails(firstRow: false)
            case 3: showAgencyDetails(firstRow: false)
            default: break
        }
    }
    
// MARK: - Bottom Values Selection
    
    func handleFirstBottomSelection(gesture: UITapGestureRecognizer) {
        
        resetFirstBottomViewsSelection()
        
        let activeColor = UIColor(red: 255/255, green: 231/255, blue: 22/255, alpha: 1.0)
        
        if let viewTag = gesture.view?.tag {
            
            firstRowSelectedTag = viewTag
            
            switch viewTag {
            case 0:
                bottomFirstProjectLabel.textColor = activeColor
                bottomFirstProjectLine.backgroundColor = activeColor
                
                showProjectDetails(firstRow: true)
                
            case 1:
                bottomFirstTaskLabel.textColor = activeColor
                bottomFirstTaskLine.backgroundColor = activeColor
                
                showTaskDetails(firstRow: true)
                
            case 2:
                bottomFirstClienLabel.textColor = activeColor
                bottomFirstClientLine.backgroundColor = activeColor
                
                showClientDetails(firstRow: true)
                
            case 3:
                bottomFirstAgencyLabel.textColor = activeColor
                bottomFirstAgencyLine.backgroundColor = activeColor
                
                showAgencyDetails(firstRow: true)
                
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
            
            secondRowSelectedTag = viewTag
            
            switch viewTag {
            case 0:
                bottomSecondProjectLabel.textColor = activeColor
                bottomSecondProjectLine.backgroundColor = activeColor
                
                showProjectDetails(firstRow: false)
                
            case 1:
                bottomSecondTaskLabel.textColor = activeColor
                bottomSecondTaskLine.backgroundColor = activeColor
                
                showTaskDetails(firstRow: false)
                
            case 2:
                bottomSecondClientLabel.textColor = activeColor
                bottomSecondClientLine.backgroundColor = activeColor
                
                showClientDetails(firstRow: false)
                
            case 3:
                bottomSecondAgencyLabel.textColor = activeColor
                bottomSecondAgencyLine.backgroundColor = activeColor
                
                showAgencyDetails(firstRow: false)
                
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
    
// MARK: - Show Detail From Selection 
    
    private func showProjectDetails(firstRow: Bool) {
        var incomeText = ""
        
        if let formattedIncome = self.numberFormatter.string(from: ArchiveUtils.getEarned(project: (self.jobProject?.id)!, archived:false) as NSNumber) {
            incomeText = formattedIncome
        }
        
        let nameText = self.jobProject?.name
        
        if firstRow {
            bottomFirstIncomeLabel.text = incomeText
            bottomFirstNameLabel.text = nameText
        } else {
            bottomSecondIncomeLabel.text = incomeText
            bottomSecondNameLabel.text = nameText
        }
    }
    
    private func showTaskDetails(firstRow: Bool) {
        
        var incomeText = ""
        
        if let formattedIncome = self.numberFormatter.string(from: ArchiveUtils.getEarned(task: (self.jobTask?.id)!) as NSNumber) {
            incomeText = formattedIncome
        }
        
        let nameText = self.jobTask?.name
        
        if firstRow {
            bottomFirstIncomeLabel.text = incomeText
            bottomFirstNameLabel.text = nameText
        } else {
            bottomSecondIncomeLabel.text = incomeText
            bottomSecondNameLabel.text = nameText
        }
    }
    
    private func showClientDetails(firstRow: Bool) {
        var incomeText = ""
        var nameText = ""
        
        if self.jobClient == nil {
            nameText = "N/A"
            incomeText = "0.00"
        } else {
            nameText = (self.jobClient?.name)!
            
            if let formattedIncome = self.numberFormatter.string(from: ArchiveUtils.getEarned(agency: (self.jobClient?.id)!, archived:false) as NSNumber) {
                incomeText = formattedIncome
            }
        }
        
        if firstRow {
            bottomFirstIncomeLabel.text = incomeText
            bottomFirstNameLabel.text = nameText
        } else {
            bottomSecondIncomeLabel.text = incomeText
            bottomSecondNameLabel.text = nameText
        }
    }
    
    private func showAgencyDetails(firstRow: Bool) {

        var incomeText = ""
        var nameText = ""
        
        if self.jobAgency == nil {
            nameText = "N/A"
            incomeText = "0.00"
        } else {
            nameText = (self.jobAgency?.name)!
            
            if let formattedIncome = self.numberFormatter.string(from: ArchiveUtils.getEarned(agency: (self.jobAgency?.id)!, archived:false) as NSNumber) {
                incomeText = formattedIncome
            }
        }
        
        if firstRow {
            bottomFirstIncomeLabel.text = incomeText
            bottomFirstNameLabel.text = nameText
        } else {
            bottomSecondIncomeLabel.text = incomeText
            bottomSecondNameLabel.text = nameText
        }
    }
    
// MARK: - Start Stop Timer
    
    @IBAction func startStopTimer(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            self.simpleTimerDelegate?.stopTimer()
            
            self.secondsLabel.isHidden = true;
            
            self.startStopButton.setImage(UIImage(named:"btn-timer-stopped-big"), for: .normal)
        } else {
            sender.isSelected = true
            
            self.simpleTimerDelegate?.startTimer()
            
            self.secondsLabel.isHidden = false;
            
            self.startStopButton.setImage(UIImage(named:"btn-timer-active-numbered"), for: .normal)
        }
        
    }
    
// MARK: - Button Long Pressed
    func buttonLongPressed(tap:UILongPressGestureRecognizer)
    {
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) == nil
        {
            return
        }
        if tap.state == .began && !startStopButton.isSelected
        {
            let globalPoint = startStopButton.superview?.convert(startStopButton.frame.origin, to: nil)
            simpleTimerDelegate?.showEditTimer(buttonFrame: CGRect(origin: globalPoint!, size: startStopButton.frame.size))
        }
    }
    
// MARK: - Timer Protocol
    
    func secondPassed(newTime: Double) {
        self.currentJobTime = newTime
        
        updateTimerValues()
        updateSecondsValue()
        updateBottomValues()
    }
    
    func updateTimerViewWithNewTime(time: Int) {
        
    }
    
    func timerStoppedFromAppClosure() {
        
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
    
    private func computeCurrentTime(time: Double) -> (days: Int, hours: Int, minutes: Int) {
        
        var days = 0
        var hours = 0
        var minutes = 0
        var currentTime = time
        
        while Int(currentTime/3600) >= self.dayLength!
        {
            days = days + 1
            currentTime = currentTime - (Double(self.dayLength!)*3600.0)
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
    
    private func computeCurrentSecondsPerMinute() -> String {
        
        let remainder = self.currentJobTime?.truncatingRemainder(dividingBy: 60.00)
        print("remaind: \(Int(remainder!))")
        return "\(Int(remainder!))"
    }
}

// MARK: - UIScrollView Delegate
extension SimpleTimerView: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
        
    }
}











