
//
//  TimerView.swift
//  Kronos
//
//  Created by Wee, David G. on 8/21/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit

protocol TimerViewDelegate {
    func startStopButtonPressed(_ active:Bool)
    func noTimerActive()
    func setTopLabels(min:Int, hrs:Int, days:Int)
    func addTime(active:Bool)
    func showEditTimer(buttonFrame: CGRect)
}

enum TimerType
{
    case Normal, ProjectTime, AllocatedTime
}

class TimerView: UIView, TimerProtocol {

    var dimView:UIView?
    //Delegate
    var delegate:TimerViewDelegate?
    
    //TimerDaysView
    let timerDaysView: CircleView! = CircleView()
    
    var minuteDidPass:() -> () = {() in }

    //MinuteView
    let minuteView : CircleView! = CircleView()
    var minutesPassed: Int = 0
    let minuteImageView : UIImageView! = UIImageView()
    var minuteViewHeight: NSLayoutConstraint?
    var minuteViewWidth: NSLayoutConstraint?
    var minutesPassedView:CirclePercentageView?
    
    //HoursView
    var hoursView : CircleView! = CircleView()
    let hoursImageView : UIImageView! = UIImageView()
    var hoursPassed:Int = 0
    var hoursPassedView:CirclePercentageView?
    
    //Start/Stop Button
    let startStopButton : UIButton! = UIButton()
    var timerIsActive = false
    
    //Timer Hand
    let timerHand: UIImageView! = UIImageView()
    var timerHandRadian:Int?
    var timer:TimerType = .Normal
    
    var cancelButton : UIButton?
    var plusButton : UIButton?
    var minusButton : UIButton?
    var okayButton : UIButton?
    var middleLine : UIView?
    var topLine : UIView?
    var bottomLine : UIView?
    
    var otherTimers:[TimerView]?
    
    var addTimeDimView : UIView?
    var tempTimeChange:Int = 0
    
    typealias Minutes = Int
    typealias Hours = Int
    typealias Days = Int
    var time: (Days, Hours, Minutes)?
    var timeInSeconds:Double!
    
    var noTimerImage:UIImageView?
    var isDim = false
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addEllipse(in: rect)
        ctx!.setFillColor(UIColor.timerBackgroundColor().cgColor.components!)
        ctx!.fillPath()
    }
    
    func initTimer()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimerView.settingsDidChange), name: NSNotification.Name(rawValue: "kSettingsChangedNotificaiton"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimerView.startStopButtonPressed(_:_:)), name: NSNotification.Name(rawValue:"kTimerDeletedNotification"), object: nil)


        // Timer Days View - This is the view with the days elapsed (yellow) and days allocated (gray)
        ChronoTimer.sharedInstance.delegates.append(self)
        timerDaysView.translatesAutoresizingMaskIntoConstraints = false
        timerDaysView.circleColor = UserDefaults.standard.colorForKey(TIMER_DAYS_BACKGROUND_COLOR)
        timerDaysView.backgroundColor = UIColor.clear
        addSubview(timerDaysView)
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: timerDaysView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: timerDaysView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.93, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.93, constant: 0.0))
        let daysImageView = UIImageView(image: UIImage(named: "img-minutes-inactive"))
        daysImageView.translatesAutoresizingMaskIntoConstraints = false
        timerDaysView.addSubview(daysImageView)
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerY, relatedBy: .equal, toItem: daysImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerX, relatedBy: .equal, toItem: daysImageView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: daysImageView, attribute: .height, relatedBy: .equal, toItem: timerDaysView, attribute: .height, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: daysImageView, attribute: .width, relatedBy: .equal, toItem: timerDaysView, attribute: .width, multiplier: 1.0, constant: 0.0))
        self.colorChanged()

        //Minute View
        minuteView.translatesAutoresizingMaskIntoConstraints = false
        minuteView.circleColor = UserDefaults.standard.colorForKey(MINUTE_VIEW_UNFILLED_BACKGROUND_COLOR)
        minuteView.backgroundColor = UIColor.clear
        minuteImageView.clipsToBounds = true
        timerDaysView.addSubview(minuteView)
        
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerX, relatedBy: .equal, toItem: minuteView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerY, relatedBy: .equal, toItem: minuteView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        var p = CGFloat(0.92)
        if timer != .Normal
        {
            p = CGFloat(0.69)
        }
        minuteViewWidth = NSLayoutConstraint(item: minuteView, attribute: .width, relatedBy: .equal, toItem: timerDaysView, attribute: .width, multiplier: p, constant: 0.0)
        timerDaysView.addConstraint(minuteViewWidth!)
        minuteViewHeight = NSLayoutConstraint(item: minuteView, attribute: .height, relatedBy: .equal, toItem: timerDaysView, attribute: .height, multiplier: p, constant: 0.0)
        timerDaysView.addConstraint(minuteViewHeight!)
        //Minutes Image
       
        minuteImageView.translatesAutoresizingMaskIntoConstraints = false
        minuteView.addSubview(minuteImageView)
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView!, attribute: .centerX, relatedBy: .equal, toItem: minuteImageView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView!, attribute: .centerY, relatedBy: .equal, toItem: minuteImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView!, attribute: .width, relatedBy: .equal, toItem: minuteImageView, attribute: .width, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView!, attribute: .height, relatedBy: .equal, toItem: minuteImageView, attribute: .height, multiplier: 1.0, constant: 0.0))
       
        
        
        //Hours View
        hoursView.translatesAutoresizingMaskIntoConstraints = false
        hoursView.circleColor = UserDefaults.standard.colorForKey(HOURS_VIEW_BACKGROUND_COLOR)
        hoursView.backgroundColor = UIColor.clear
        hoursView.clipsToBounds = true
        timerDaysView.insertSubview(hoursView, aboveSubview: minuteView)
        
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerX, relatedBy: .equal, toItem: hoursView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: timerDaysView, attribute: .centerY, relatedBy: .equal, toItem: hoursView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .width, relatedBy: .equal, toItem: timerDaysView, attribute: .width, multiplier: 0.55, constant: 0.0))
        timerDaysView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .height, relatedBy: .equal, toItem: timerDaysView, attribute: .height, multiplier: 0.55, constant: 0.0))
      
        //Hours Image
      
        hoursImageView.translatesAutoresizingMaskIntoConstraints = false
        hoursView.addSubview(hoursImageView)
        
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView!, attribute: .centerX, relatedBy: .equal, toItem: hoursImageView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView!, attribute: .centerY, relatedBy: .equal, toItem: hoursImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView!, attribute: .width, relatedBy: .equal, toItem: hoursImageView, attribute: .width, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView!, attribute: .height, relatedBy: .equal, toItem: hoursImageView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        checkHoursAndMinutesSettings()
        
        //Start/Stop Button
        startStopButton.setImage(UIImage(named: "btn-timer-stopped"), for: [])
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        insertSubview(startStopButton, aboveSubview: hoursImageView)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: startStopButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: startStopButton, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: startStopButton!, attribute: .width, relatedBy: .equal, toItem: hoursView, attribute: .width, multiplier: 0.4, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: startStopButton!, attribute: .height, relatedBy: .equal, toItem: hoursView, attribute: .height, multiplier: 0.4, constant: 0.0))
        if timer == .Normal {
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed(tap:)))
                longpress.minimumPressDuration = 1
                startStopButton.addGestureRecognizer(longpress)
        }
        
        //Timer Hand
        timerHand.image = UIImage(named: "img-timer-hand")
        timerHand.contentMode = .scaleAspectFit
        timerHand.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(timerHand, belowSubview: startStopButton)
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: timerHand, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: timerHand, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: timerHand, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: timerHand, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0.0))
     
        

    }
    
    func drawPercentageCircles()
    {
        if minutesPassedView != nil { return }
        //Minutes Passed View
        minutesPassedView?.removeFromSuperview()
        minutesPassedView?.tag = -1
        minutesPassedView = CirclePercentageView()
        minutesPassedView?.backgroundColor = UIColor.clear
        minutesPassedView?.translatesAutoresizingMaskIntoConstraints = false
        minutesPassedView?.color = UserDefaults.standard.colorForKey(MINUTE_VIEW_FILLED_BACKGROUND_COLOR)!
        minutesPassedView?.percentage = Double(minutesPassed)
        minuteView.insertSubview(minutesPassedView!, belowSubview: minuteImageView)
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView, attribute: .centerX, relatedBy: .equal, toItem: minutesPassedView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView, attribute: .centerY, relatedBy: .equal, toItem: minutesPassedView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView, attribute: .width, relatedBy: .equal, toItem: minutesPassedView, attribute: .width, multiplier: 1.0, constant: 0.0))
        minuteView.addConstraint(NSLayoutConstraint(item: minuteView, attribute: .height, relatedBy: .equal, toItem: minutesPassedView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        //Hours Percentage View
        hoursPassedView = CirclePercentageView()
        hoursPassedView?.tag = -1
        hoursPassedView?.color = UserDefaults.standard.colorForKey("timerColor")!
        hoursPassedView?.translatesAutoresizingMaskIntoConstraints = false
        hoursPassedView?.backgroundColor = UIColor.clear
        hoursPassedView?.percentage = 0
        hoursView.insertSubview(hoursPassedView!, belowSubview: hoursImageView)
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .centerX, relatedBy: .equal, toItem: hoursPassedView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .centerY, relatedBy: .equal, toItem: hoursPassedView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .width, relatedBy: .equal, toItem: hoursPassedView, attribute: .width, multiplier: 1.0, constant: 0.0))
        hoursView.addConstraint(NSLayoutConstraint(item: hoursView, attribute: .height, relatedBy: .equal, toItem: hoursPassedView, attribute: .height, multiplier: 1.0, constant: 0.0))
        
    }
    
    func drawRadialCircles(_ row:Int)
    {
        var count = 0
        var tagCount = -1
        for i in 0...72
        {
            if i%6 != 0
            {
                let circleHeight = timerDaysView.bounds.size.height * 0.025
                let p = 275*i
                
                let point = pointOnCircle(CGPoint(x: timerDaysView.bounds.size.height/2, y: timerDaysView.bounds.size.height/2), radius: timerDaysView.bounds.size.height/2 - floor(circleHeight)-0.5 + 1.0 - ((circleHeight*1.5)*CGFloat(row)) , angle: CGFloat((275*i).degreesToRadians))
                let v = UIView(frame: CGRect(x:0,y:0,width:circleHeight,height:circleHeight))
                v.tag = p % 360 / 5 + 15 - 69
                if v.tag < 0 { v.tag = 72 + v.tag }
                if row != 0 { v.tag = v.tag + 72*row }
                v.center = point
                timerDaysView.insertSubview(v, belowSubview: minuteView)
                
                v.layer.cornerRadius = circleHeight/2
                v.layer.borderWidth = 1
                v.layer.borderColor = UIColor.unfilledUnAllocatedDayCircle().cgColor
                
            }
            else
            {
                count = count + 1
                tagCount = tagCount + 1
            }
            
        }
        setupCircles()
    }
    

    
    func setupCircles()
    {
        var daysElapsed = 0
        var daysAlloctaed = 0
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) == nil { return }
        let currentJobTimer = JobTimer.getTimerWith(id: (UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! NSNumber).intValue)
        
        
      
        
        if timer == .Normal
        {
            let task = StageTask.getStageTask(forId: (currentJobTimer?.stageTaskId.intValue)!)
            let project = Project.getProject(forId: (task!.projectId.intValue))
            daysAlloctaed = Int(floor(task!.allocatedTaskTime.doubleValue / (project?.dayLength.doubleValue)!))
            daysElapsed = ArchiveUtils.getHoursWorked(task: (task?.id)!).0

            daysElapsed = Int(floor(Double(daysElapsed/project!.dayLength.intValue)))
            var daysElapsedArray = (-1)...(-1)
            daysAlloctaed = daysAlloctaed + (daysAlloctaed / 5)
            daysElapsed = daysElapsed + (daysElapsed / 5)
            if daysElapsed > 0
            {
                daysElapsedArray = 1...daysElapsed
            }
            var daysAllocatedArray = (-1)...(-1)
            if daysAlloctaed > 0 {
                daysAllocatedArray = 1...daysAlloctaed
            }
            for s in timerDaysView.subviews
            {
                if daysAllocatedArray.contains(s.tag)
                {
                    s.backgroundColor = UIColor.lightGray
                    s.layer.borderColor = UIColor.lightGray.cgColor
                }
                
                if daysElapsedArray.contains(s.tag)
                {
                    let color = UserDefaults.standard.colorForKey("timerColor")
                    s.backgroundColor = color!
                    s.layer.borderColor = color!.cgColor
                }
            }
        }
        else if timer == .ProjectTime
        {
            let task = StageTask.getStageTask(forId: (currentJobTimer?.stageTaskId.intValue)!)
            let project = Project.getProject(forId: (task?.projectId.intValue)!)
            daysAlloctaed = Int(project!.allocatedProjectTime.intValue / project!.dayLength.intValue)
            daysElapsed = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false).0

            daysElapsed = Int(floor(Double(daysElapsed/project!.dayLength.intValue)))
            var daysElapsedArray = (-1)...(-1)

            daysElapsed = daysElapsed + (daysElapsed / 5)
            if daysElapsed > 0
            {
                daysElapsedArray = 1...daysElapsed
            }

            var allocatedCircles:[Int]!
            allocatedCircles = []
            if daysAlloctaed != 0
            {
                for a in 1...daysAlloctaed
                {
                    if a % 20 > 0 && a % 20 < 6
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(216+(a%20))
                        }
                        else
                        {
                            allocatedCircles.append(217+((a%20)+(x*5))+(x-1))
                        }
                    }
                        
                    else if a % 20 > 5 && a % 20 < 11
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(144+((a-5)%20))
                        }
                        else
                        {
                            allocatedCircles.append(145+(((a-5)%20)+(x*5)) + (x-1))
                        }
                    }
                        
                    else if a % 20 > 10 && a % 20 < 16
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(72+((a-10)%20))
                        }
                        else
                        {
                            allocatedCircles.append(73+(((a-10)%20)+(x*5))+(x-1))
                        }
                    }
                    else
                    {
                        let x = Int(a/20)
                        if x == 0 || a%20 == 0
                        {
                            var num = ((a-15)%20)
                            if x > 1
                            {
                                num = num + (5+(x-1) + (5*(x-2)))
                            }
                            allocatedCircles.append(num)
        
                        }
                        else
                        {
                            allocatedCircles.append(1+(((a-15)%20)+(x*5))+(x-1))
                        }
                    }
                }
            }
            
            var elapsedCircles:[Int]!
            elapsedCircles = []
            if daysElapsed > 0
            {
                for a in 1...daysElapsed
                {
                    if a % 20 > 0 && a % 20 < 6
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(216+(a%20))
                        }
                        else
                        {
                            elapsedCircles.append(217+((a%20)+(x*5))+(x-1))
                        }
                    }
                        
                    else if a % 20 > 5 && a % 20 < 11
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(144+((a-5)%20))
                        }
                        else
                        {
                            elapsedCircles.append(145+(((a-5)%20)+(x*5)) + (x-1))
                        }
                    }
                        
                    else if a % 20 > 10 && a % 20 < 16
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(72+((a-10)%20))
                        }
                        else
                        {
                            elapsedCircles.append(73+(((a-10)%20)+(x*5))+(x-1))
                        }
                    }
                    else
                    {
                        let x = Int(a/20)
                        if x == 0 || a%20 == 0
                        {
                            var num = ((a-15)%20)
                            if x > 1
                            {
                                num = num + (5+(x-1) + (5*(x-2)))
                            }
                            elapsedCircles.append(num)
                            
                        }
                        else
                        {
                            elapsedCircles.append(1+(((a-15)%20)+(x*5))+(x-1))
                        }
                    }
                }
            }

            
            for s in timerDaysView.subviews
            {
                if allocatedCircles.contains(s.tag)
                {
                    s.backgroundColor = UIColor.lightGray
                    s.layer.borderColor = UIColor.lightGray.cgColor
                }
                
                if elapsedCircles.contains(s.tag)
                {
                    let color = UserDefaults.standard.colorForKey("timerColor")
                    s.backgroundColor = color!
                    s.layer.borderColor = color!.cgColor
                }
            }
 
        }
        else if timer == .AllocatedTime
        {
            let task = StageTask.getStageTask(forId: (currentJobTimer?.stageTaskId.intValue)!)
            let project = Project.getProject(forId: (task?.projectId.intValue)!)
            daysAlloctaed = Int(floor(project!.allocatedProjectTime.doubleValue / project!.dayLength.doubleValue))
            
            //hours
            let totalHoursWorked = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false).0
            
            //minutes
            let totalMinutesWorked = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false).1
            
            if totalMinutesWorked >= 0 {
                daysElapsed = totalHoursWorked + 1
            } else {
                daysElapsed = totalHoursWorked
            }
            
//            daysElapsed = ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false).0
//            daysElapsed = daysElapsed + ArchiveUtils.getHoursWorked(project: (project?.id)!, archived: false).1/60
            daysElapsed = Int(floor(Double(daysElapsed/project!.dayLength.intValue)))
            var daysElapsedArray = (-1)...(-1)
            
            daysElapsed = daysElapsed + (daysElapsed / 5)
            if daysElapsed > 0
            {
                daysElapsedArray = 1...daysElapsed
            }
            
            var allocatedCircles:[Int]!
            allocatedCircles = []
            if daysAlloctaed != 0
            {
                for a in 1...daysAlloctaed
                {
                    if a % 20 > 0 && a % 20 < 6
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(216+(a%20))
                        }
                        else
                        {
                            allocatedCircles.append(217+((a%20)+(x*5))+(x-1))
                        }
                    }
                        
                    else if a % 20 > 5 && a % 20 < 11
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(144+((a-5)%20))
                        }
                        else
                        {
                            allocatedCircles.append(145+(((a-5)%20)+(x*5)) + (x-1))
                        }
                    }
                        
                    else if a % 20 > 10 && a % 20 < 16
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            allocatedCircles.append(72+((a-10)%20))
                        }
                        else
                        {
                            allocatedCircles.append(73+(((a-10)%20)+(x*5))+(x-1))
                        }
                    }
                    else
                    {
                        let x = Int(a/20)
                        if x == 0 || a%20 == 0
                        {
                            var num = ((a-15)%20)
                            if x > 1
                            {
                                num = num + (5+(x-1) + (5*(x-2)))
                            }
                            allocatedCircles.append(num)
                            
                        }
                        else
                        {
                            allocatedCircles.append(1+(((a-15)%20)+(x*5))+(x-1))
                        }
                    }
                }
            }
            
            var elapsedCircles:[Int]!
            elapsedCircles = []
            if daysElapsed > 0
            {
                for a in 1...daysElapsed
                {
                    if a % 20 > 0 && a % 20 < 6
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(216+(a%20))
                        }
                        else
                        {
                            elapsedCircles.append(217+((a%20)+(x*5))+(x-1))
                        }
                    }
                        
                    else if a % 20 > 5 && a % 20 < 11
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(144+((a-5)%20))
                        }
                        else
                        {
                            elapsedCircles.append(145+(((a-5)%20)+(x*5)) + (x-1))
                        }
                    }
                        
                    else if a % 20 > 10 && a % 20 < 16
                    {
                        let x = Int(a/20)
                        if x == 0
                        {
                            elapsedCircles.append(72+((a-10)%20))
                        }
                        else
                        {
                            elapsedCircles.append(73+(((a-10)%20)+(x*5))+(x-1))
                        }
                    }
                    else
                    {
                        let x = Int(a/20)
                        if x == 0 || a%20 == 0
                        {
                            var num = ((a-15)%20)
                            if x > 1
                            {
                                num = num + (5+(x-1) + (5*(x-2)))
                            }
                            elapsedCircles.append(num)
                            
                        }
                        else
                        {
                            elapsedCircles.append(1+(((a-15)%20)+(x*5))+(x-1))
                        }
                    }
                }
            }
            
            
            for s in timerDaysView.subviews
            {
                
                if allocatedCircles.contains(s.tag)
                {
                    let color = UserDefaults.standard.colorForKey("timerColor")
                    s.backgroundColor = color!
                    s.layer.borderColor = color!.cgColor
                }
                
                if elapsedCircles.contains(s.tag)
                {
                    s.backgroundColor = UIColor.lightGray
                    s.layer.borderColor = UIColor.lightGray.cgColor
                }
                

            }

        }
    }
    
    
    func pointOnCircle(_ center:CGPoint, radius:CGFloat, angle:CGFloat) -> CGPoint
    {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    
    //***********************************
    
    func getTimeForTimer(updateOthers:Bool = false)
    {
        if updateOthers
        {
            for t in otherTimers!
            {
                DispatchQueue.main.async {
                    t.getTimeForTimer()
                }
            }
        }
        if let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int
        {
            let job = JobTimer.getTimerWith(id: id)!
            //var time = job.timeSpent.doubleValue
            let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
            let project = Project.getProject(forId: task!.projectId.intValue)
            
            var dayLength = project?.dayLength.intValue
            if dayLength == nil || dayLength == 0
            {
                dayLength = 8
            }
            let currentTimeFromTimer = ChronoTimer.sharedInstance.getCurrentTime()
            
            switch timer {
            case .Normal:

                getDaysHoursMinFrom(time: currentTimeFromTimer, dayLength: dayLength!)
                break
                
            case .ProjectTime:
                let currentProjectTime  = DataController.sharedInstance.getAllTimeSpentOnProject(project: project!.id)
                getDaysHoursMinFrom(time: currentProjectTime, dayLength: dayLength!)
      
                break
            case .AllocatedTime:
//                let projectTimeAllocated = (project?.allocatedProjectTime.intValue)! / dayLength!
//                let projectTimePast = DataController.sharedInstance.getAllTimeSpentOnProject(project: project!.id)
//                let allocatedTimeInSeconds = Double(projectTimeAllocated)*Double(dayLength!)*60.0*60.0
                let projectTimeAllocated = (project?.allocatedProjectTime.intValue)!
                let projectTimePast = DataController.sharedInstance.getAllTimeSpentOnProject(project: project!.id)
                let allocatedTimeInSeconds = Double(projectTimeAllocated)*60.0*60.0
                getDaysHoursMinFrom(time: allocatedTimeInSeconds - projectTimePast, dayLength: dayLength!)
                break
            }
        }
    }
    
    
    func getDaysHoursMinFrom(time:Double, dayLength:Int)
    {
        var days = 0
        var hours = 0
        var minutes = 0
        var currentTime = time
        timeInSeconds = time
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
        self.time = (days, hours, minutes)

    }

    func getDisplayTime(time: Double, dayLength: Int) -> (Int, Int, Int) {
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


    func checkCurrentTimerPosition()
    {
        if let leftOn = UserDefaults.standard.value(forKey: TIMER_IS_ON) as? Bool
        {
            if leftOn == true
            {
                let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int

                if UserDefaults.standard.value(forKey: "closeDate") != nil
                {
                    let secondsPassed = Date().timeIntervalSince(UserDefaults.standard.value(forKey: "closeDate") as! Date)
                    let time = JobTimer.getTimerWith(id: id!)!.timeSpent.doubleValue
                    DataController.sharedInstance.updateCurrentJobTimer(timer: secondsPassed+time)
                    UserDefaults.standard.removeObject(forKey: "closeDate")
                }
            }
        }
       
        if let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int
        {
            let job = JobTimer.getTimerWith(id: id)!
            let time = job.timeSpent.doubleValue
            
            ChronoTimer.sharedInstance.setTime(time: time)
   
            self.getTimeForTimer()

            let percent = timeInSeconds.truncatingRemainder(dividingBy: 60)/60
            let rotations = 360.00*percent
           
            timerHand.transform = CGAffineTransform(rotationAngle: CGFloat(rotations.degreesToRadians))
            minutesPassed = ChronoTimer.sharedInstance.currentMinutes!
            
            minutesPassed = self.time!.2

            minutesPassedView?.percentage = (Double(minutesPassed).multiplied(by: 1.0.divided(by: 120.0)))
            minutesPassedView?.setNeedsDisplay()
            hoursPassed = self.time!.1

            hoursPassedView?.percentage =  (Double(hoursPassed).multiplied(by: 1.0)).divided(by: 24)
            hoursPassedView?.setNeedsDisplay()
        }else
        {
            timerHand.transform = CGAffineTransform(rotationAngle: CGFloat(0.degreesToRadians))
            
            minutesPassedView?.percentage = 0
            minutesPassedView?.setNeedsDisplay()
           
            hoursPassedView?.percentage =  0
            hoursPassedView?.setNeedsDisplay()
            return
        }
        if let leftOn = UserDefaults.standard.value(forKey: TIMER_IS_ON) as? Bool
        {
            if leftOn
            {
                if !timerIsActive
                {
                    self.startStopButtonPressed()
                    UserDefaults.standard.set(false, forKey: TIMER_IS_ON)  
                }
                else{
                    startStopTimer()
                }
            }
        }
    }
    
// MARK: - Button Long Pressed
    func buttonLongPressed(tap:UILongPressGestureRecognizer)
    {
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) == nil
        {
            return
        }
        if tap.state == .began && !timerIsActive
        {
//            delegate?.addTime(active: true)
            let globalPoint = startStopButton.superview?.convert(startStopButton.frame.origin, to: nil)
            delegate?.showEditTimer(buttonFrame: CGRect(origin: globalPoint!, size: startStopButton.frame.size))
            
//            editTimerView = EditTimerView.instanceFromNib()
//            editTimerView.editTimerDelegate = self
//            editTimerView.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(editTimerView)
//            
//            addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: editTimerView, attribute: .leading, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: editTimerView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: editTimerView, attribute: .top, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: editTimerView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
//            layoutSubviews()

            
//            cancelButton = UIButton()
//            cancelButton?.setImage(UIImage(named:"timer-increment-close"), for: .normal)
//            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
//            cancelButton?.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
//            addSubview(cancelButton!)
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerX, relatedBy: .equal, toItem: cancelButton!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerY, relatedBy: .equal, toItem: cancelButton!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .width, relatedBy: .equal, toItem: cancelButton!, attribute: .width, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .height, relatedBy: .equal, toItem: cancelButton!, attribute: .height, multiplier: 1.0, constant: 0.0))
//            
//            minusButton = UIButton()
//            minusButton?.setImage(UIImage(named:"timer-increment-minus"), for: .normal)
//            minusButton?.translatesAutoresizingMaskIntoConstraints = false
//            minusButton?.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
//            addSubview(minusButton!)
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerX, relatedBy: .equal, toItem: minusButton!, attribute: .centerX, multiplier: 0.6, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerY, relatedBy: .equal, toItem: minusButton!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .width, relatedBy: .equal, toItem: minusButton!, attribute: .width, multiplier: 0.75, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .height, relatedBy: .equal, toItem: minusButton!, attribute: .height, multiplier: 0.75, constant: 0.0))
//            
//            plusButton = UIButton()
//            plusButton?.setImage(UIImage(named:"timer-increment-plus"), for: .normal)
//            plusButton?.translatesAutoresizingMaskIntoConstraints = false
//            plusButton?.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
//            addSubview(plusButton!)
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerX, relatedBy: .equal, toItem: plusButton!, attribute: .centerX, multiplier: 0.6, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerY, relatedBy: .equal, toItem: plusButton!, attribute: .centerY, multiplier: 2.4, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .width, relatedBy: .equal, toItem: plusButton!, attribute: .width, multiplier: 0.75, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .height, relatedBy: .equal, toItem: plusButton!, attribute: .height, multiplier: 0.75, constant: 0.0))
//            
//            okayButton = UIButton()
//            okayButton?.translatesAutoresizingMaskIntoConstraints = false
//            okayButton?.setImage(UIImage(named:"timer-increment-okay"), for: .normal)
//            okayButton?.addTarget(self, action: #selector(okayButtonPressed), for: .touchUpInside)
//            addSubview(okayButton!)
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerX, relatedBy: .equal, toItem: okayButton!, attribute: .centerX, multiplier: 0.6, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerY, relatedBy: .equal, toItem: okayButton!, attribute: .centerY, multiplier: 0.63, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .width, relatedBy: .equal, toItem: okayButton!, attribute: .width, multiplier: 0.75, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .height, relatedBy: .equal, toItem: okayButton!, attribute: .height, multiplier: 0.75, constant: 0.0))
//            
//            middleLine = UIView()
//            middleLine?.translatesAutoresizingMaskIntoConstraints = false
//            middleLine?.backgroundColor = UIColor.white
//            insertSubview(middleLine!, belowSubview: cancelButton!)
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .centerY, relatedBy: .equal, toItem: middleLine!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: startStopButton, attribute: .trailing, relatedBy: .equal, toItem: middleLine!, attribute: .leading, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: minusButton!, attribute: .leading, relatedBy: .equal, toItem: middleLine!, attribute: .trailing, multiplier: 1.0, constant: -20.0))
//            addConstraint(NSLayoutConstraint(item: middleLine!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 5.0))
//            
//            topLine = UIView(frame:CGRect(x: startStopButton.center.x, y: startStopButton.center.y - 50, width: 100, height: 5))
//            topLine?.translatesAutoresizingMaskIntoConstraints = false
//            topLine?.backgroundColor = UIColor.white
//            insertSubview(topLine!, belowSubview: cancelButton!)
//            topLine?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
//            
//            bottomLine = UIView(frame:CGRect(x: startStopButton.center.x, y: startStopButton.center.y + 50, width: 100, height: 5))
//            bottomLine?.translatesAutoresizingMaskIntoConstraints = false
//            bottomLine?.backgroundColor = UIColor.white
//            insertSubview(bottomLine!, belowSubview: cancelButton!)
//            bottomLine?.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
//
//            addTimeDimView = UIView()
//            addTimeDimView?.translatesAutoresizingMaskIntoConstraints = false
//            addTimeDimView?.backgroundColor = UIColor.black
//            addTimeDimView?.alpha = 0.7
//            
//          
//            
//            self.insertSubview(addTimeDimView!, belowSubview: cancelButton!)
//            
//            addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: addTimeDimView!, attribute: .leading, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: addTimeDimView!, attribute: .trailing, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: addTimeDimView!, attribute: .top, multiplier: 1.0, constant: 0.0))
//            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: addTimeDimView!, attribute: .bottom, multiplier: 1.0, constant: 0.0))
//                layoutSubviews()
//                for timer in otherTimers!
//                {
//                    timer.layoutSubviews()
//                }
//              addTimeDimView?.layer.cornerRadius = (addTimeDimView?.bounds.size.width)!/2
        }
    }
    
    func updateTimerViewWithNewTime(time: Int) {
        tempTimeChange = time
        ChronoTimer.sharedInstance.addtime(time: tempTimeChange)
        updateCalenderDay(time: time)
        //updateMinuteAndHourCircles(true)
        tempTimeChange = 0
        getTimeForTimer(updateOthers: true)
    }
    
    func updateCalenderDay(time:Int)
    {
        let currentTimerId = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! NSNumber
        let currentTimer = JobTimer.getTimerWith(id: currentTimerId.intValue)
        let currentTaskId = currentTimer?.stageTaskId.intValue
        if let calenderDay = CalendarDay.exists(date: Date().simpleDate() as NSDate, taskId: currentTaskId!)
        {
            calenderDay.timeWorked = calenderDay.timeWorked + Double(time*60)
        }
        else
        {
            let calenderDay = CalendarDay.createNewCalendarDay(date: Date().simpleDate() as NSDate, withTask: currentTaskId!)
            calenderDay.timeStarted = Date() as NSDate
            calenderDay.timeWorked = Double(time)
        }
        try! DataController.sharedInstance.managedObjectContext.save()
    
    }
    
    func updateMinuteAndHourCircles(_ updateOthers:Bool = false)
    {
        if updateOthers
        {
            for t in otherTimers!
            {
                DispatchQueue.main.async {
                    t.updateMinuteAndHourCircles()
                }
            }
        }
        
        // Removed plus code to fix extra minute sometimes get added
        var time = ChronoTimer.sharedInstance.currentTime! //+ Double(tempTimeChange)
        
        let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int
        let job = JobTimer.getTimerWith(id: id!)
        let task = StageTask.getStageTask(forId: (job?.stageTaskId.intValue)!)
        
        if timer == .ProjectTime
        {
            time = Double(tempTimeChange) + DataController.sharedInstance.getAllTimeSpentOnProject(project: (task?.projectId)!)
        }
        else if timer == .AllocatedTime
        {
            let totalProjectTime = DataController.sharedInstance.getTotalTimeForProject(project: task!.projectId)
            time = totalProjectTime  - (Double(tempTimeChange) + DataController.sharedInstance.getAllTimeSpentOnProject(project: (task?.projectId)!))
        }
        
        let times = secondsToHoursMinutesSeconds(seconds: Int(time))
        minutesPassed = times.1
        hoursPassed = times.0

        minutesPassedView?.percentage = (Double(minutesPassed).multiplied(by: 1.0.divided(by: 120.0)))
        minutesPassedView?.setNeedsDisplay()
        

        let project = Project.getProject(forId: task!.projectId.intValue)
        
        var intVal = project?.dayLength.intValue
        if intVal == nil || intVal == 0
        {
            intVal = 8
        }
        
        while hoursPassed >= intVal! {
            hoursPassed = hoursPassed - intVal!
        }
        
        hoursPassedView?.percentage =  (Double(hoursPassed).multiplied(by: 1.0)).divided(by: 24)
        hoursPassedView?.setNeedsDisplay()
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
// MARK: - Edit Timer Okay Button Pressed
//    func okayButtonPressed()
//    {
//        ChronoTimer.sharedInstance.addtime(time: tempTimeChange)
//        updateCalenderDay(time: tempTimeChange)
//        updateMinuteAndHourCircles(true)
//        tempTimeChange = 0
//        getTimeForTimer(updateOthers: true)
//
//        self.cancelButtonPressed()
//        self.layoutSubviews()
//        for t in otherTimers!
//        {
//            t.layoutSubviews()
//        }
//    }
    
// MARK: - Edit Timer Plus Button Pressed
//    func plusButtonPressed()
//    {
//        tempTimeChange = tempTimeChange + 1
//        let tempTime = ChronoTimer.sharedInstance.getCurrentTime() + Double(tempTimeChange*60)
//        
//        let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
//        delegate?.setTopLabels(min: times.1, hrs: times.0, days: 0)
//        
//    }
    
// MARK: - Edit Timer Minus Button Pressed
//    func minusButtonPressed()
//    {
//        tempTimeChange = tempTimeChange - 1
//        let tempTime = ChronoTimer.sharedInstance.currentTime! + Double(tempTimeChange*60)
//        
//        if tempTime <= 0
//        {
//            tempTimeChange = tempTimeChange + 1
//            return
//        }
//        else
//        {
//            let times = secondsToHoursMinutesSeconds(seconds: Int(tempTime))
//            delegate?.setTopLabels(min: times.1, hrs: times.0, days: 0)
//        }
//    }
//
    
// MARK: - Edit Timer Cancel Button Pressed
//    func cancelButtonPressed()
//    {
//        delegate?.addTime(active: false)
//        
//        //        editTimerView.removeFromSuperview()
//        
//        //        addTimeDimView?.removeFromSuperview()
//        //        addTimeDimView = nil
//        //        okayButton?.removeFromSuperview()
//        //        plusButton?.removeFromSuperview()
//        //        minusButton?.removeFromSuperview()
//        //        cancelButton?.removeFromSuperview()
//        //        middleLine?.removeFromSuperview()
//        //        topLine?.removeFromSuperview()
//        //        bottomLine?.removeFromSuperview()
//        
//        let times = secondsToHoursMinutesSeconds(seconds: Int(ChronoTimer.sharedInstance.currentTime!))
//        delegate?.setTopLabels(min: times.1, hrs: times.0, days: 0)
//        tempTimeChange = 0
//        
//    }
    
// MARK: - Start Stop Button Pressed
    func buttonPressed()
    {
        startStopButtonPressed()
    }
    
    func startStopButtonPressed(_ tellDelegate:Bool = true, _ tellOtherTimers:Bool = true)
    {
        if tellOtherTimers
        {
            for t in otherTimers!
            {
                DispatchQueue.main.async {
                    t.startStopButtonPressed(false, false)
                }
            }
        }
        
        if UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) != nil || timerIsActive
        {
            if timerIsActive{
                timerIsActive = false
                startStopButton.setImage(UIImage(named: "btn-timer-stopped"), for: [])
                if tellDelegate
                {
                    ChronoTimer.sharedInstance.stopTimer()
                }
            }else
            {
                timerIsActive = true
                startStopButton.setImage(UIImage(named: "btn-timer-active"), for: [])
                if tellDelegate
                {
                    if ChronoTimer.sharedInstance.currentTime != nil || ChronoTimer.sharedInstance.currentTime == 0.00 {
                        ChronoTimer.sharedInstance.startTimer()
                    }
                    else
                    {
                        ChronoTimer.sharedInstance.startNewTimer()
                    }
                }
            }
            startStopTimer()
            if tellDelegate
            {
                delegate?.startStopButtonPressed(timerIsActive)
            }
        }
        else
        {
            if tellDelegate
            {
                delegate?.noTimerActive()
            }
        }
    }
    
    
    func startStopTimer()
    {
        if timerIsActive
        {
            var rotationAnimation = CABasicAnimation()
            rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            if timer == .AllocatedTime
            {
                rotationAnimation.toValue = NSNumber(floatLiteral: -(M_PI * 2.0 * 1 * 60))
            }
            else
            {
                rotationAnimation.toValue = NSNumber(floatLiteral: M_PI * 2.0 * 1 * 60)
            }
            rotationAnimation.beginTime = CACurrentMediaTime()
            rotationAnimation.speed = 1.0

            rotationAnimation.duration = 3600
            
            rotationAnimation.repeatCount = Float.infinity
            timerHand.layer.add(rotationAnimation, forKey: "rotationAnimation")
            

        }
        else
        {
            let timerHandRadian = timerHand.layer.presentation()?.value(forKeyPath: "transform.rotation.z")
            timerHand.layer.removeAllAnimations()
            timerHand.transform = CGAffineTransform(rotationAngle: timerHandRadian as! CGFloat)
        }
    }
    
    
    //MARK: - Notification Actions
    func colorChanged()
    {
        if (UserDefaults.standard.value(forKey: "timerDaysBackgroundColor") as! String).trimmingCharacters(in: .whitespaces) == "WHITE"
        {
            timerDaysView.circleColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
        else
        {
             timerDaysView.circleColor = UIColor.timerDaysBackgroundColorDefault()
        }
        hoursPassedView?.color = UserDefaults.standard.colorForKey("timerColor")!
        minutesPassedView?.color = UserDefaults.standard.colorForKey(MINUTE_VIEW_FILLED_BACKGROUND_COLOR)!
        minutesPassedView?.tag = -1
        hoursPassedView?.tag = -1
        hoursPassedView?.setNeedsDisplay()
        timerDaysView.setNeedsDisplay()
        self.layoutSubviews()
    }
    
    
    func checkHoursAndMinutesSettings()
    {
        if let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int
        {
   
            let job = JobTimer.getTimerWith(id: id)!
            let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
            let project = Project.getProject(forId: task!.projectId.intValue)
            
            var intVal = project?.dayLength.intValue
            if intVal == nil || intVal == 0
            {
                intVal = 8
            }
            if UserDefaults.standard.value(forKey: "timerMarkingsMins") as! Bool == true
            {
                minuteImageView.image = UIImage(named: "img-minutes-active")
            }
            else
            {
                minuteImageView.image = UIImage(named: "img-minutes-inactive")
            }
            minuteImageView.setNeedsDisplay()
            if UserDefaults.standard.value(forKey: "timerMarkingsHours") as! Bool == true
            {
                hoursImageView.image = UIImage(named: activeImageArray[intVal!-1])
            }
            else
            {
                hoursImageView.image = UIImage(named: inactiveImageArray[intVal!-1])
            }
            hoursImageView.setNeedsDisplay()
        }
    }
    
    func settingsDidChange()
    {
        colorChanged()
        checkHoursAndMinutesSettings()
        drawLabelOnCircle()
    }
    
    //MARK: - TimerProtocol
    
    func secondPassed(newTime:Double)
    {
        let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as! Int
        let job = JobTimer.getTimerWith(id: id)!
        let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
        let project = Project.getProject(forId: task!.projectId.intValue)
        
        var dayLength = project?.dayLength.intValue
        if dayLength == nil || dayLength == 0
        {
            dayLength = 8
        }
        if timer == .AllocatedTime
        {
            getDaysHoursMinFrom(time: timeInSeconds-1, dayLength: dayLength!)
        }
        else
        {
            getDaysHoursMinFrom(time: timeInSeconds+1, dayLength: dayLength!)
        }

        if timer == .Normal {
            //print("NORMAL -> \(timeInSeconds)")
            job.timeSpent = NSNumber(value: newTime)
            try! DataController.sharedInstance.managedObjectContext.save()
        }
        else if timer == .ProjectTime {
               //print("PROJECT-> \(timeInSeconds)")
        }

        if timer == .AllocatedTime {
            if (time?.2)! < minutesPassed || (time?.1)! < hoursPassed {
                self.minutesPassedView?.percentage = (Double(self.time!.2).multiplied(by: 1.0.divided(by: 120.0)))
                self.minutesPassedView?.setNeedsDisplay()
                self.hoursPassedView?.percentage =  (Double(self.time!.1).multiplied(by: 1.0)).divided(by: 24)
                self.hoursPassedView?.setNeedsDisplay()
                //self.layoutSubviews()
            } else {
                self.minutesPassedView?.percentage = (Double(self.time!.2).multiplied(by: 1.0.divided(by: 120.0)))
                self.minutesPassedView?.setNeedsDisplay()
                self.hoursPassedView?.percentage =  (Double(self.time!.1).multiplied(by: 1.0)).divided(by: 24)
                self.hoursPassedView?.setNeedsDisplay()
                //self.layoutSubviews()
            }
        } else {
            if (time?.2)! > minutesPassed || (time?.1)! > hoursPassed {
                self.minutesPassedView?.percentage = (Double(self.time!.2).multiplied(by: 1.0.divided(by: 120.0)))
                self.minutesPassedView?.setNeedsDisplay()
                self.hoursPassedView?.percentage =  (Double(self.time!.1).multiplied(by: 1.0)).divided(by: 24)
                self.hoursPassedView?.setNeedsDisplay()
                //self.layoutSubviews()
            }
        }
        
//        if (time?.2)! > minutesPassed || (time?.1)! > hoursPassed {
//            self.minutesPassedView?.percentage = (Double(self.time!.2).multiplied(by: 1.0.divided(by: 120.0)))
//            self.minutesPassedView?.setNeedsDisplay()
//            self.hoursPassedView?.percentage =  (Double(self.time!.1).multiplied(by: 1.0)).divided(by: 24)
//            self.hoursPassedView?.setNeedsDisplay()
//            self.layoutSubviews()
//        }
        
        minutesPassed = time!.2
        hoursPassed = time!.1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kCheckTime"), object: nil)


    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for v in timerDaysView.subviews
        {
            if v.tag > 0
            {
                v.removeFromSuperview()
            }
        }
        
        if timer != .Normal
        {
            for i in 0...3
            {
                drawRadialCircles(i)
            }
        }
        else { drawRadialCircles(0) }
        drawPercentageCircles()
        if !isDim {
            drawLabelOnCircle()
        }
        if noTimerImage != nil { noTimerImage?.removeFromSuperview()
            noTimerImage = nil
        }
        if timer == .AllocatedTime
        {
            if let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int
            {
                let job = JobTimer.getTimerWith(id: id)!
                //var time = job.timeSpent.doubleValue
                let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
                let project = Project.getProject(forId: task!.projectId.intValue)
                if project?.allocatedProjectTime == nil || project?.allocatedProjectTime == 0
                {
                    noTimerImage = UIImageView(image: UIImage(named: "timer-off"))
                    noTimerImage!.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(noTimerImage!)
                    addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: noTimerImage, attribute: .leading, multiplier: 1.0, constant: 0.0))
                    addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: noTimerImage, attribute: .trailing, multiplier: 1.0, constant: 0.0))
                    addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: noTimerImage, attribute: .top, multiplier: 1.0, constant: 0.0))
                    addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: noTimerImage, attribute: .bottom, multiplier: 1.0, constant: 0.0))
                    noTimerImage!.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    func startNewTimer(_ setTimer:Bool = false)
    {
        setupNewTimer(setTimer)
    }
    
    func stopTimer(_ setTimer:Bool = false)
    {
        if setTimer
        {
            ChronoTimer.sharedInstance.currentTimer?.invalidate()
            ChronoTimer.sharedInstance.isActive = false
            ChronoTimer.sharedInstance.currentTime = nil
        }
        
        timerHand.transform = CGAffineTransform(rotationAngle: 0)
        minutesPassed = 0
        minuteView.setNeedsDisplay()
        hoursPassed = 0
        hoursView.setNeedsDisplay()
        timerIsActive = false
        //let timerHandRadian = timerHand.layer.presentation()?.value(forKeyPath: "transform.rotation.z")
        timerHand.layer.removeAllAnimations()
        timerHand.transform = CGAffineTransform(rotationAngle: 0)
        startStopButton.setImage(UIImage(named: "btn-timer-stopped"), for: [])

        
    }
    
    func setDim(dim:Bool)
    {
        for v in subviews {
            if v is UILabel {
                v.isHidden = true
            }
        }
        isDim = dim
        if dim{
            
            dimView = UIView()
            dimView!.translatesAutoresizingMaskIntoConstraints = false
            dimView?.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
           self.addSubview(dimView!)
            addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: dimView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: dimView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: dimView, attribute: .width, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: dimView, attribute: .height, multiplier: 1.0, constant: 0.0))
            layoutSubviews()
            if timer != .Normal
            {
                minuteViewHeight?.isActive = false
                minuteViewWidth?.isActive = false
                minuteViewHeight = NSLayoutConstraint(item: minuteView, attribute: .height, relatedBy: .equal, toItem: timerDaysView, attribute: .height, multiplier: 0.92, constant: 0.0)
                timerDaysView.addConstraint(minuteViewHeight!)
                minuteViewWidth = NSLayoutConstraint(item: minuteView, attribute: .width, relatedBy: .equal, toItem: timerDaysView, attribute: .width, multiplier: 0.92, constant: 0.0)
                timerDaysView.addConstraint(minuteViewWidth!)
            }
            dimView?.layer.cornerRadius = (dimView?.bounds.size.width)!/2

            layoutSubviews()

        }
        else
        {
            dimView?.removeFromSuperview()
            dimView = nil
            
            if timer != .Normal
            {
                minuteViewHeight?.isActive = false
                minuteViewWidth?.isActive = false
                minuteViewHeight = NSLayoutConstraint(item: minuteView, attribute: .height, relatedBy: .equal, toItem: timerDaysView, attribute: .height, multiplier: 0.69, constant: 0.0)
                timerDaysView.addConstraint(minuteViewHeight!)
                minuteViewWidth = NSLayoutConstraint(item: minuteView, attribute: .width, relatedBy: .equal, toItem: timerDaysView, attribute: .width, multiplier: 0.69, constant: 0.0)
                timerDaysView.addConstraint(minuteViewWidth!)
            }
            
            
        }
        minuteImageView.isHidden = dim
        startStopButton.isHidden = dim
        timerHand.isHidden = dim
        hoursImageView.isHidden = dim
        hoursView.isHidden = dim
        minutesPassedView?.isHidden = dim
        hoursPassedView?.isHidden = dim
        layoutSubviews()
        
    }
    
    func setupNewTimer(_ setNewTimer:Bool = false)
    {
        if timerIsActive
        {
            if setNewTimer
            {
                startStopButtonPressed()
//                ChronoTimer.sharedInstance.currentTime = 0.0
//                ChronoTimer.sharedInstance.currentMinutes = 0
//                ChronoTimer.sharedInstance.currentHours = 0
//                ChronoTimer.sharedInstance.second = 0
            }
            else
            {
                startStopButtonPressed(false, false)
            }
        }
        
        ChronoTimer.sharedInstance.currentTime = 0.0
        ChronoTimer.sharedInstance.currentMinutes = 0
        ChronoTimer.sharedInstance.currentHours = 0
        ChronoTimer.sharedInstance.second = 0
        
        time = (0,0,0)
        timerHand.transform = CGAffineTransform(rotationAngle: 0)
        minutesPassed = 0
        minutesPassedView?.percentage = 0
        minutesPassedView?.setNeedsDisplay()
        minuteView.setNeedsDisplay()
        hoursPassed = 0
        hoursView.setNeedsDisplay()
        hoursPassedView?.percentage = 0
        hoursPassedView?.setNeedsDisplay()
        checkHoursAndMinutesSettings()
        getTimeForTimer(updateOthers: setNewTimer)
    }
    
    
    func drawLabelOnCircle()
    {
        
        for v in self.subviews
        {
            if v.tag == -55
            {
                v.isHidden = true
                (v as! UILabel).textColor = UIColor.red
                v.removeFromSuperview()
            }
        }
        
        if isDim { return }
        let vis = (UserDefaults.standard.value(forKey: "timerNumberVisability") as! String).replacingOccurrences(of: " ", with: "")
        if vis == "OFF" { return }
        else if vis == "ALL"
        {
            for i in 1...60
            {
                if i % 5 == 0
                {
                    addLabel(i: i)
                    addInnerLabel(i: i)
                }
            }
        }
        else if vis == "CURRENT"
        {
            addLabel(i: minutesPassed)
            addInnerLabel(i: hoursPassed*5)
        }
        else if vis == "ELAPSED"
        {
            for i in 0...minutesPassed
            {
                if i % 5 == 0 && i != 0
                {
                    addLabel(i: i)
                }
            }
            for i in 0...hoursPassed
            {
                if i != 0 {
                    addInnerLabel(i: i*5)
                }
            }

        }
    }
    
    func addLabel(i:Int)
    {
        var num = 45+i
        if num >= 60 {
            num = num - 60
        }

        var minutes = 0
        if let id = UserDefaults.standard.value(forKey: CURRENT_JOB_TIMER) as? Int{
            let job = JobTimer.getTimerWith(id: id)!
            let time = job.timeSpent.doubleValue
           
            if timer == .Normal
            {
                ChronoTimer.sharedInstance.setTime(time: time)
                minutes = ChronoTimer.sharedInstance.currentMinutes!
            }
            else if timer == .ProjectTime
            {
                let task = StageTask.getStageTask(forId: job.stageTaskId.intValue)
                let project = Project.getProject(forId: task!.projectId.intValue)
                let time = DataController.sharedInstance.getAllTimeSpentOnProject(project: project!.id)
                ChronoTimer.sharedInstance.setTime(time: time)
                minutes = ChronoTimer.sharedInstance.currentMinutes!
            }
            else
            {
                
            }
        }
        
        let circlePercent = (Double(num))/60.0 * 360.0
        let centerX = self.bounds.size.width/2
        let centerY = self.bounds.size.height/2
        
        let pointX = centerX + (minuteView.bounds.size.width/2 - 8) * CGFloat(cos(circlePercent.degreesToRadians))
        let pointY = centerY + (minuteView.bounds.size.width/2 - 8) * CGFloat(sin(circlePercent.degreesToRadians))
        let label = UILabel(frame:CGRect.zero)
        label.tag = -55
        if timer == .Normal
        {
            label.font = UIFont().smallFont()
        }
        else
        {
            label.font = UIFont().smallerFont()
        }
       
        label.text = String(format: "%02d", i)

        if i >  minutes
        {
            label.textColor = UIColor.white
        }
        else
        {
            label.textColor = UIColor.homeScreenBackground()
        }
        label.sizeToFit()
        label.center = CGPoint(x: pointX, y: pointY)
        addSubview(label)
    }
    
    func addInnerLabel(i:Int)
    {
        var num = 45+i
        if num >= 60 {
            num = num - 60
        }
        let circlePercent = (Double(num)-1)/60.0 * 360.0
        let centerX = self.bounds.size.width/2
        let centerY = self.bounds.size.height/2
        
        let pointX = centerX + (hoursView.bounds.size.width/2 - 8) * CGFloat(cos(circlePercent.degreesToRadians))
        let pointY = centerY + (hoursView.bounds.size.width/2 - 8) * CGFloat(sin(circlePercent.degreesToRadians))
        let label = UILabel(frame:CGRect.zero)
        label.tag = -55
        label.font = UIFont().smallFont()


        label.text = String(format: "%02d", i/5)
        label.textColor = UIColor.timerBackgroundColor()
        label.sizeToFit()
        label.center = CGPoint(x: pointX, y: pointY)
        addSubview(label)
    }
}
