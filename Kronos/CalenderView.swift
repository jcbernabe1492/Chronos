//
//  CalenderView.swift
//  Kronos
//
//  Created by Wee, David G. on 9/29/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import UIKit







class CalenderView: UIView, ChronoCalender, DayViewDelegate {
    var year:Int?
    var currentMonth:Int?
    var days:Array<DayView> = []
    var delegate:CalenderViewDelegate?
    var swipeStartX:CGFloat?
    var swipeStartY:CGFloat?
    
    var stackView1:UIStackView?
    var stackView2:UIStackView?
    
    var calenderLeadingConstraint:NSLayoutConstraint!
    var topConstraint:NSLayoutConstraint?
    var leadingConstraint:NSLayoutConstraint?
    var trailingConstraint:NSLayoutConstraint?
    
    var dayViewArray:[DayView] = []
    
    var previousDaySelected: DayView?
    var todayDay: DayView?
    
    init(month:Int, year:Int)
    {
        self.year = year
        self.currentMonth = month
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        initValues()
        drawDayLabels()
        loadStackView()
        self.clipsToBounds = true
    }
    
    
    func initValues()
    {
        backgroundColor = UIColor.cellBackgroundColor()
    }
    
    func reloadView()
    {
        for v in self.subviews
        {
            v.removeFromSuperview()
        }
        days = []
        drawDayLabels()
        loadStackView()
    }
    
    func refreshCurrentMonth() {
        self.todayDay?.setupDayImage()
        self.todayDay?.setNeedsDisplay()
        self.todayDay?.layoutSubviews()
    }
    
    func loadStackView()
    {
        if stackView1 != nil
        {
            stackView1?.removeFromSuperview()
            stackView1 = nil
        }
        stackView1 = drawDaysOnView()
        addSubview(stackView1!)
        let top:NSLayoutConstraint?
        if UIScreen().isiPhone6Plus() || UIScreen().isiPhone6()
        {
             top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView1, attribute: .top, multiplier: 1.0, constant: -30.0)
        }
        else
        {
             top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView1, attribute: .top, multiplier: 1.0, constant: -25.0)
        }
        addConstraint(top!)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackView1, attribute: .leading, multiplier: 1.0, constant: -10.0)
        addConstraint(leading)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView1, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        addConstraint(trailing)
        
        topConstraint = top
        leadingConstraint = leading
        trailingConstraint = trailing
        isUserInteractionEnabled = true
    }
    
    func drawDayLabels()
    {
        var dayStackArray:Array<UILabel> = []
        for day in iterateEnum(DaysOfTheWeek.self)
        {
            let label = UILabel()
            label.font = UIFont().boldFont()
            label.textAlignment = .center
            label.text = "\(day.rawValue.characters.first!)"
            label.textColor = UIColor.white
            dayStackArray.append(label)
        }
        let stackDayView = UIStackView(arrangedSubviews: dayStackArray)
        stackDayView.axis = .horizontal
        stackDayView.distribution = .fillEqually
        stackDayView.alignment = .center
        stackDayView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackDayView)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackDayView, attribute: .top, multiplier: 1.0, constant: -5.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackDayView, attribute: .leading, multiplier: 1.0, constant: -5.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackDayView, attribute: .trailing, multiplier: 1.0, constant: 5.0))
        self.addConstraint(NSLayoutConstraint(item: stackDayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
    }
    
    func drawDaysOnView() -> UIStackView
    {
        var startDay = Date.getDayOfWeek(dateString: "\(year!)/\(currentMonth!)/1")-1
        if startDay == 0 { startDay = 7}
        var rowArray:Array<UIStackView> = []
        var count = 1
        var dayCount = 0
        for _ in 0...5
        {
            var dayArray:Array<UIView> = []
            for _ in 1...7
            {
                var dayActive = false
                if count < startDay
                {
                    dayCount = Date.getNumberOfDays(month: currentMonth!, year: year!) - (startDay - count) + 1
                }
                else if count-startDay >= Date.getNumberOfDays(month: currentMonth!, year: year!)
                {
                    dayCount = count - (Date.getNumberOfDays(month: currentMonth!, year: year!) + startDay - 1)
                }
                else
                {
                    dayCount = count - startDay + 1
                    dayActive = true
                }
                
                let day = Day(day: dayCount, month: currentMonth!, year:year!, parent:self)
                let dayView = DayView(day: day)
               
                dayView.delegate = self
                dayView.setupDayImage()
                dayView.tag = 100 + count
                dayViewArray.append(dayView)
                
                if !dayActive
                {
                    dayView.setInactive()
                }
                else
                {
                    dayView.setActive()
                    days.append(dayView)
                }
                let ratio = NSLayoutConstraint(item: dayView, attribute: .height, relatedBy: .equal, toItem: dayView, attribute: .width, multiplier: 1.0, constant: 0.0)
                ratio.priority = 999
                dayView.addConstraint(ratio)
                dayArray.append(dayView)
                
                count = count + 1
            }
  
            let stackRow = UIStackView(arrangedSubviews: dayArray)
            stackRow.translatesAutoresizingMaskIntoConstraints = false
            stackRow.spacing = 10
            stackRow.distribution = .fillEqually
            
            rowArray.append(stackRow)
        }
        
        let totalDaysStackView = UIStackView(arrangedSubviews: rowArray)
        totalDaysStackView.translatesAutoresizingMaskIntoConstraints = false
        totalDaysStackView.axis = .vertical
        totalDaysStackView.distribution = .fillEqually
        totalDaysStackView.spacing = 8
        
        self.setNeedsDisplay()
        self.layoutSubviews()
        
        return totalDaysStackView
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Day View Delegate Methods
    
    func dayViewWasPressed(day: Day) {
        self.previousDaySelected?.isSelected = false
        self.previousDaySelected?.setupDayImage()
        self.previousDaySelected?.setNeedsDisplay()
        self.previousDaySelected?.layoutSubviews()
        
//        for d in days{
//            if d.isSelected
//            {
//                d.isSelected = false
//                d.setupDayImage()
//                d.setNeedsDisplay()
//                d.layoutSubviews()
//            }
//            else if d.day == day
//            {
//                d.isSelected = true
//                d.setupDayImage()
//                d.setNeedsDisplay()
//                d.layoutSubviews()
//            }
//            
//        }
        
        if delegate != nil
        {
            delegate?.dayViewWasPressed(day: day)
        }
    }
    
    func updatePreviouseDaySelected(dayView: DayView) {
        self.previousDaySelected = dayView
    }
    
    func setTodayDayView(dayView: DayView) {
        self.todayDay = dayView
    }
    
    func updateDayView(dayView:Day, type:DAY_TYPE)
    {
        for d in days
        {
             if (d.day?.equals(day: dayView))!
             {
                UserDefaults.standard.set(type.rawValue, forKey: "\(d.day!.month)/\(d.day!.day)/\(d.day!.year)")
                d.setupDayImage()
                d.setNeedsDisplay()
                d.layoutSubviews()
            }
        }
    }
    

}
