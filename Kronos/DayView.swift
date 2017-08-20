//
//  DayView.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit


let DAY_HOURS = 60.0*60.0*12.0
let ONE_HOUR = 60.0*60.0


protocol DayViewDelegate
{
    func dayViewWasPressed(day:Day)
    func updatePreviouseDaySelected(dayView: DayView)
    func setTodayDayView(dayView: DayView)
}

class DayView: UIView {

    var day:Day?
    
    var dayNumberLabel:UILabel!
    var hourView:CirclePercentageView?
    var overtimeHourView:CirclePercentageView?
    
    var backgroundImage:UIImageView?
    var innerCircle:UIView?
    var outerCircle:UIView?
    var innerCornerRadius:CGFloat?
    var outerCornerRadius:CGFloat?
    var isSelected = false
    var active:Bool = true
    var today: Bool = false

    var delegate:DayViewDelegate? = nil
    
    init(day:Day)
    {
        self.day = day
        backgroundImage = UIImageView()
        backgroundImage?.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    

    func setActive()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(DayView.dayWasClicked))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func setupDayImage()
    {
        for v in self.subviews
        {
            v.removeFromSuperview()
        }
        let view = setupViewWith(type: (day?.type)!)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        if Date(day: day!.day, month:day!.month , year: day!.year).isToday()
        {
            if active {
                outerCircle?.layer.borderColor = UIColor.black.cgColor
                outerCircle?.layer.borderWidth = 2
                innerCircle?.layer.borderColor = UIColor.black.cgColor
                innerCircle?.layer.borderWidth = 2
                backgroundImage?.image = UIImage(named: "img-calendar-day-off-today")
                
                delegate?.updatePreviouseDaySelected(dayView: self)
                delegate?.setTodayDayView(dayView: self)
            }
        }
        else if isSelected
        {
            outerCircle?.layer.borderColor = UIColor.black.cgColor
            outerCircle?.layer.borderWidth = 2
            backgroundImage?.image = UIImage(named: "img-calendar-day-off-today")
            
            delegate?.updatePreviouseDaySelected(dayView: self)
        }
        else
        {
            outerCircle?.layer.borderColor = UIColor.black.cgColor
            outerCircle?.layer.borderWidth = 0
            innerCircle?.layer.borderColor = UIColor.black.cgColor
            innerCircle?.layer.borderWidth = 0
        }
        setupDayValues()

    }
    
    
    func setupViewWith(type:DAY_TYPE) -> UIView
    {
        let returnView:UIView = UIView()
        
        innerCircle = UIView()
        innerCircle?.backgroundColor = UIColor.white
        innerCircle?.translatesAutoresizingMaskIntoConstraints = false
        returnView.addSubview(innerCircle!)
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerY, relatedBy: .equal, toItem: innerCircle, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerX, relatedBy: .equal, toItem: innerCircle, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .width, relatedBy: .equal, toItem: innerCircle, attribute: .width, multiplier: 2.0, constant: 0.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .height, relatedBy: .equal, toItem: innerCircle, attribute: .height, multiplier: 2.0, constant: 0.0))
        
        outerCircle = UIView()
        outerCircle?.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        outerCircle?.translatesAutoresizingMaskIntoConstraints = false
        returnView.insertSubview(outerCircle!, belowSubview: innerCircle!)
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerX, relatedBy: .equal, toItem: outerCircle, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerY, relatedBy: .equal, toItem: outerCircle, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .width, relatedBy: .equal, toItem: outerCircle, attribute: .width, multiplier: 1.0, constant: 0.35))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .height, relatedBy: .equal, toItem: outerCircle, attribute: .height, multiplier: 1.0, constant: 0.35))
        
        dayNumberLabel = UILabel()
        dayNumberLabel.textAlignment = .center
        dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        if UIScreen().isiPhone6() || UIScreen().isiPhone6Plus()
        {
            dayNumberLabel.font = UIFont(name: "NeoSans-Medium", size: 10)
        }
        else
        {
            dayNumberLabel.font = UIFont(name: "NeoSans-Medium", size: 8)
        }
        dayNumberLabel.textColor = UIColor(red: 147/255, green: 148/255, blue: 150/255, alpha: 1.0)
        dayNumberLabel.text = "\(String(format: "%02d", (day?.day)!))"
        returnView.insertSubview(dayNumberLabel, aboveSubview: innerCircle!)
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerY, relatedBy: .equal, toItem: dayNumberLabel, attribute: .centerY, multiplier: 1.0, constant: -1.0))
        returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerX, relatedBy: .equal, toItem: dayNumberLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        
        switch type {
        case .AVAILABLE:
            
            break
        case .DAY_OFF:

            backgroundImage = UIImageView()
            backgroundImage?.image = UIImage(named: "img-calendar-day-off")
            backgroundImage?.translatesAutoresizingMaskIntoConstraints = false
            returnView.insertSubview(backgroundImage!, belowSubview: dayNumberLabel!)
            returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerX, relatedBy: .equal, toItem: backgroundImage, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .centerY, relatedBy: .equal, toItem: backgroundImage, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .width, relatedBy: .equal, toItem: backgroundImage, attribute: .width, multiplier: 1.0, constant: 0.0))
            returnView.addConstraint(NSLayoutConstraint(item: returnView, attribute: .height, relatedBy: .equal, toItem: backgroundImage, attribute: .height, multiplier: 1.0, constant: 0.0))
            outerCircle?.isHidden = true
            break
        case .FULL_DAY:
            
            innerCircle?.backgroundColor = UIColor(red: 240/255, green: 80/255, blue: 50/255, alpha: 1.0)
            dayNumberLabel.textColor = UIColor.white
            break
        case .HALF_DAY:
            dayNumberLabel.textColor = UIColor(red: 240/255, green: 80/255, blue: 50/255, alpha: 1.0)
            break
        }
        
        return returnView
    }
    
    func setupDayValues()
    {
        if hourView != nil
        {
            hourView?.removeFromSuperview()
            hourView = nil
        }
        
        if overtimeHourView != nil
        {
            overtimeHourView?.removeFromSuperview()
            overtimeHourView = nil
        }
        
        let taskTimes = CalenderUtils.getTimeWorked(day: day!)
        if taskTimes.isEmpty {return}
        
        var totalTimeWorked = 0.0
        for task in taskTimes
        {
            totalTimeWorked = totalTimeWorked + task.value
        }
        
        //var hours = floor(totalTimeWorked/60/60)
        var hours = round(totalTimeWorked/60/60)
        let percent = (ONE_HOUR*hours / DAY_HOURS )/2
        if hourView == nil
        {
            let view = subviews[0]
            hourView = CirclePercentageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            hourView?.translatesAutoresizingMaskIntoConstraints = false
            hourView?.backgroundColor = UIColor.clear
            view.insertSubview(hourView!, belowSubview: innerCircle!)
            if Date(day: day!.day, month:day!.month , year: day!.year).isToday() || isSelected
            {
                
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: hourView, attribute: .width, multiplier: 1.0, constant: 4.0))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: hourView, attribute: .height, multiplier: 1.0, constant: 4.0))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: hourView, attribute: .centerX, multiplier: 1.0, constant: 1))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: hourView, attribute: .centerY, multiplier: 1.0, constant: 1))
            }
            else
            {
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: hourView, attribute: .width, multiplier: 1.0, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: hourView, attribute: .height, multiplier: 1.00, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: hourView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: hourView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            }
        }
        
        if hours > 12
        {
            hours = hours - 12
            let percentO = (ONE_HOUR*hours / DAY_HOURS )/2
            if overtimeHourView == nil
            {
                let view = subviews[0]
                overtimeHourView = CirclePercentageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                overtimeHourView?.tag = -1
                overtimeHourView?.translatesAutoresizingMaskIntoConstraints = false
                overtimeHourView?.backgroundColor = UIColor.clear
                view.insertSubview(overtimeHourView!, aboveSubview: hourView!)
                if !Date(day: day!.day, month:day!.month , year: day!.year).isToday()
                {
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: overtimeHourView, attribute: .width, multiplier: 1.0, constant: 4))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: overtimeHourView, attribute: .height, multiplier: 1.00, constant: 4))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: overtimeHourView, attribute: .centerX, multiplier: 1.0, constant: 1))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: overtimeHourView, attribute: .centerY, multiplier: 1.0, constant: 1))
                }
                else
                {
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: overtimeHourView, attribute: .width, multiplier: 1.0, constant: 0.0))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: overtimeHourView, attribute: .height, multiplier: 1.00, constant: 0.0))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: overtimeHourView, attribute: .centerX, multiplier: 1.00, constant: 0.0))
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: overtimeHourView, attribute: .centerY, multiplier: 1.00, constant: 0.0))
                }
            }
            overtimeHourView?.color = UIColor.black
            overtimeHourView?.percentage = percentO
        }
        hourView?.color = UserDefaults.standard.colorForKey("timerColor")!
        hourView?.percentage = percent
    }
    
    func setInactive()
    {
        active = false
        innerCircle?.backgroundColor = UIColor.clear
        outerCircle?.backgroundColor = UIColor.clear
        backgroundImage?.removeFromSuperview()
        
        backgroundImage = UIImageView()
        backgroundImage?.image = UIImage(named: "img-calender-blank")
        backgroundImage?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImage!)
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: backgroundImage, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: backgroundImage, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: backgroundImage, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: backgroundImage, attribute: .height, multiplier: 1.0, constant: 0.0))
        
        outerCircle?.layer.borderColor = UIColor.black.cgColor
        outerCircle?.layer.borderWidth = 0
        innerCircle?.layer.borderColor = UIColor.black.cgColor
        innerCircle?.layer.borderWidth = 0
        backgroundImage?.image = UIImage(named: "img-calender-blank")
        
        hourView?.isHidden = true
        overtimeHourView?.isHidden = true
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func dayWasClicked()
    {
        if delegate == nil
        {
            if superview is DayViewDelegate
            {
                (superview as! DayViewDelegate).dayViewWasPressed(day: day!)
            }
        } else {
            delegate?.dayViewWasPressed(day: day!)
        }
        
        self.isSelected = true
        self.setupDayImage()
        self.setNeedsDisplay()
        self.layoutSubviews()
        
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        outerCornerRadius = (outerCircle?.bounds.size.height)!/CGFloat(2)
        innerCornerRadius =  (innerCircle?.bounds.size.height)!/CGFloat(2)
        outerCircle?.layer.cornerRadius = outerCornerRadius!
        innerCircle?.layer.cornerRadius = innerCornerRadius!
    }
    
    

}


extension Day:Comparable
{
    static func < (lhs: Day, rhs: Day) -> Bool
    {
        if Date(day: lhs.day, month: lhs.month, year: lhs.year) < Date(day: rhs.day, month: rhs.month, year: rhs.year)
        {
            return true
        }
        return false
    }
    static func > (lhs: Day, rhs: Day) -> Bool
    {
        if Date(day: lhs.day, month: lhs.month, year: lhs.year) > Date(day: rhs.day, month: rhs.month, year: rhs.year)
        {
            return true
        }
        return false
    }
    static func == (lhs: Day, rhs: Day) -> Bool
    {
        if Date(day: lhs.day, month: lhs.month, year: lhs.year) == Date(day: rhs.day, month: rhs.month, year: rhs.year)
        {
            return true
        }
        return false
    }
}
